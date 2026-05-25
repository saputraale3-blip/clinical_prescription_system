import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../services/local_ai_chat_service.dart';

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

  // =====================================================
  // SEND MESSAGE
  // =====================================================

  void sendMessage() {

    if (messageController.text
        .trim()
        .isEmpty) {

      return;
    }

    final userMessage =
        messageController.text;

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

    final aiReply =
        LocalAIChatService
            .generateReply(

      message: userMessage,

      weightKg: weight,
    );

    messages.add(

      ChatMessage(

        text: aiReply,

        isUser: false,
      ),
    );

    messageController.clear();

    setState(() {});
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
                  const EdgeInsets.all(
                24,
              ),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  const Text(

                    'AI Clinical Chat',

                    style: TextStyle(

                      color:
                          Colors.white,

                      fontSize: 32,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(

                    'Local AI Assistant',

                    style: TextStyle(

                      color: Colors.white
                          .withOpacity(
                        0.5,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  TextField(

                    controller:
                        weightController,

                    keyboardType:
                        TextInputType.number,

                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                    ),

                    decoration:
                        InputDecoration(

                      hintText:
                          'Patient Weight (kg)',

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
                ],
              ),
            ),

            // =====================================================
            // CHAT
            // =====================================================

            Expanded(

              child: ListView.builder(

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