import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/chat_message.dart';
import '../services/auth_service.dart';
import '../services/local_ai_chat_service.dart';
import '../services/supabase_service.dart';

class AIChatPage
    extends StatefulWidget {

  const AIChatPage({
    super.key,
  });

  @override
  State<AIChatPage> createState() =>
      _AIChatPageState();
}

class _AIChatPageState
    extends State<AIChatPage> {

  final TextEditingController
      messageController =
      TextEditingController();

  final TextEditingController
      weightController =
      TextEditingController();

  final List<ChatMessage>
      messages = [];

      final ScrollController
    scrollController =
    ScrollController();

      bool isLoading = true;

bool hasAccess = false;

String userRole = '';

@override
void initState() {

  super.initState();

  checkAccess();
}

Future<void> checkAccess() async {

  final userData =
      await SupabaseService
          .getCurrentUserData();

  final role =
      (userData?['role'] ?? '')
          .toString()
          .toLowerCase();

  userRole = role;

  hasAccess =
      role == 'pro' ||
      role == 'admin';

  setState(() {

    isLoading = false;
  });
}

  // =====================================================
  // SEND MESSAGE
  // =====================================================

void sendMessage() async {

  // =====================================================
  // EMPTY CHECK
  // =====================================================

  if (messageController.text
      .trim()
      .isEmpty) {

    return;
  }

  // =====================================================
  // AI LIMIT CHECK
  // =====================================================

  if (AuthService.isAiLimitReached()) {

    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(

        content: Text(
          'Daily AI limit reached (30/day)',
        ),
      ),
    );

    return;
  }

  final userMessage =
      messageController.text;

  // =====================================================
  // USER MESSAGE
  // =====================================================

  messages.add(

    ChatMessage(

      text: userMessage,

      isUser: true,
    ),
  );

  final weight =
      double.tryParse(
            weightController.text,
          ) ??
          0;

  // =====================================================
  // AI REPLY
  // =====================================================

  final aiReply =
      LocalAIChatService
          .generateReply(

    message: userMessage,

    weightKg: weight,
  );

  // =====================================================
  // SAVE CHAT COUNT
  // =====================================================

  AuthService.currentAiChatCount++;

  await Supabase.instance.client
      .from('profiles')
      .update({

    'ai_chat_count':
        AuthService.currentAiChatCount,

  }).eq(

    'id',

    Supabase.instance.client
        .auth.currentUser!.id,
  );

  // =====================================================
  // AI MESSAGE
  // =====================================================

  messages.add(

    ChatMessage(

      text: aiReply,

      isUser: false,
    ),
  );

  scrollToBottom();

  messageController.clear();

  setState(() {});
}

void scrollToBottom() {

  Future.delayed(
    const Duration(milliseconds: 100),
    () {

      if (scrollController
          .hasClients) {

        scrollController.animateTo(

          scrollController
              .position
              .maxScrollExtent,

          duration:
              const Duration(
            milliseconds: 300,
          ),

          curve: Curves.easeOut,
        );
      }
    },
  );
}

  // =====================================================
  // BUILD BUBBLE
  // =====================================================

  Widget buildBubble(
    ChatMessage message,
  ) {

    return Align(

      alignment:

          message.isUser

              ? Alignment.centerRight

              : Alignment.centerLeft,

      child: Container(

        margin:
            const EdgeInsets.symmetric(
          vertical: 8,
        ),

        padding:
            const EdgeInsets.all(
          18,
        ),

        constraints:
            const BoxConstraints(
          maxWidth: 420,
        ),

        decoration:
            BoxDecoration(

          color:

              message.isUser

                  ? Colors.cyanAccent

                  : const Color(
                      0xff1e293b,
                    ),

          borderRadius:
              BorderRadius.circular(
            24,
          ),
        ),

        child: Text(

          message.text,

          style: TextStyle(

            color:

                message.isUser

                    ? Colors.black

                    : Colors.white,

            fontSize: 16,

            height: 1.6,
          ),
        ),
      ),
    );
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(BuildContext context) {

    if (isLoading) {

  return const Scaffold(

    body: Center(

      child:
          CircularProgressIndicator(),
    ),
  );
}

if (!hasAccess) {

  return Scaffold(

    backgroundColor:
        const Color(0xff020617),

    body: Center(

      child: Container(

        margin:
            const EdgeInsets.all(24),

        padding:
            const EdgeInsets.all(30),

        decoration: BoxDecoration(

          borderRadius:
              BorderRadius.circular(28),

          color:
              Colors.white.withOpacity(0.05),

          border: Border.all(
            color: Colors.redAccent,
          ),
        ),

        child: Column(

          mainAxisSize:
              MainAxisSize.min,

          children: [

            const Icon(

              Icons.lock,

              color:
                  Colors.redAccent,

              size: 70,
            ),

            const SizedBox(
              height: 20,
            ),

            const Text(

              'PRO FEATURE',

              style: TextStyle(

                color:
                    Colors.redAccent,

                fontSize: 28,

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 14,
            ),

            Text(

              'Your role: $userRole\n\nAI Chat only available for PRO and ADMIN users.',

              textAlign:
                  TextAlign.center,

              style: TextStyle(

                color: Colors.white
                    .withOpacity(0.7),

                fontSize: 17,

                height: 1.7,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

    return Scaffold(

      backgroundColor:
          const Color(
        0xff020617,
      ),

      body: SafeArea(

        child: Column(

          children: [

// =====================================================
// HEADER
// =====================================================

Container(

  padding:
      const EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 18,
  ),

  child: Column(

    crossAxisAlignment:
        CrossAxisAlignment.start,

    children: [

      const Text(

        'AI Clinical Chat',

        style: TextStyle(

          color: Colors.white,

          fontSize: 32,

          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(
        height: 6,
      ),

      Text(

        'Local AI Assistant',

        style: TextStyle(

          color:
              Colors.white.withOpacity(
            0.5,
          ),

          fontSize: 14,
        ),
      ),

      const SizedBox(
        height: 18,
      ),

      // =====================================================
      // AI USAGE BAR
      // =====================================================

      if (hasAccess)

        Container(

          padding:
              const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),

          decoration: BoxDecoration(

            borderRadius:
                BorderRadius.circular(22),

            color:
                Colors.white.withOpacity(0.04),

            border: Border.all(

              color:
                  Colors.white.withOpacity(
                0.06,
              ),
            ),
          ),

          child: LayoutBuilder(

            builder:
                (context, constraints) {

              final isMobile =
                  constraints.maxWidth <
                      600;

              return Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  if (isMobile)

                    Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        const Text(

                          'AI Usage Today',

                          style: TextStyle(

                            color:
                                Colors.white,

                            fontSize: 15,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        Row(

                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,

                          children: [

                            Text(

                              '${AuthService.currentAiChatCount} / 30',

                              style:
                                  const TextStyle(

                                color:
                                    Colors.cyanAccent,

                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            Text(

                              '${30 - AuthService.currentAiChatCount} remaining',

                              style: TextStyle(

                                color: Colors
                                    .white
                                    .withOpacity(
                                  0.6,
                                ),

                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )

                  else

                    Row(

                      children: [

                        const Text(

                          'AI Usage Today',

                          style: TextStyle(

                            color:
                                Colors.white,

                            fontSize: 15,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const Spacer(),

                        Text(

                          '${AuthService.currentAiChatCount} / 30',

                          style:
                              const TextStyle(

                            color:
                                Colors.cyanAccent,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(
                          width: 24,
                        ),

                        Text(

                          '${30 - AuthService.currentAiChatCount} chats remaining today',

                          style: TextStyle(

                            color:
                                Colors.white
                                    .withOpacity(
                              0.6,
                            ),

                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(
                    height: 14,
                  ),

                  ClipRRect(

                    borderRadius:
                        BorderRadius.circular(
                      30,
                    ),

                    child:
                        LinearProgressIndicator(

                      value:
                          AuthService.currentAiChatCount /
                              30,

                      minHeight: 10,

                      backgroundColor:
                          Colors.white
                              .withOpacity(
                        0.08,
                      ),

                      valueColor:
                          const AlwaysStoppedAnimation(

                        Colors.cyanAccent,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
    ],
  ),
),

            // =====================================================
            // CHAT
            // =====================================================

            Expanded(

              child: ListView.builder(

controller:
    scrollController,

                padding:
                    const EdgeInsets.all(
                  20,
                ),

                itemCount:
                    messages.length,

                itemBuilder:
                    (
                  context,
                  index,
                ) {

                  return buildBubble(
                    messages[index],
                  );
                },
              ),
            ),

            // =====================================================
            // INPUT
            // =====================================================

            Container(

              padding:
                  const EdgeInsets.all(
                20,
              ),

              child: Row(

                children: [

                  Expanded(

                    child: TextField(

                      controller:
                          messageController,

                      style:
                          const TextStyle(
                        color:
                            Colors.white,
                      ),

                      decoration:
                          InputDecoration(

                        hintText:
                            'Type message...',

                        hintStyle:
                            const TextStyle(
                          color:
                              Colors.white54,
                        ),

                        filled: true,

                        fillColor:
                            const Color(
                          0xff111827,
                        ),

                        border:
                            OutlineInputBorder(

                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  FloatingActionButton(

                    backgroundColor:
                        Colors.cyanAccent,

                    onPressed:
                        sendMessage,

                    child: const Icon(

                      Icons.send,

                      color:
                          Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}