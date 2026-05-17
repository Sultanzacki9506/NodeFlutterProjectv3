import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../core/constants/colors.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;

  void _sendMessage() async {
    final userMsg = _controller.text.trim();
    if (userMsg.isEmpty) return;

    setState(() {
      _messages.add({"text": userMsg, "isUser": true});
      _isTyping = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      // Panggil API NLP dari python
      String botRes = await ApiService().askChatbot(userMsg);

      // Cek apakah widget masih di mount sebelum memanggil setState
      if (mounted) {
        setState(() {
          _messages.add({"text": botRes, "isUser": false});
          _isTyping = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add({
            "text": "Gagal mendapatkan respons.",
            "isUser": false,
          });
          _isTyping = false;
        });
        _scrollToBottom();
      }
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Widget chat bubble bergaya Neobrutalism
  Widget _buildChatBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? AppColors.accentYellow : AppColors.cardColor,
          border: Border.all(color: AppColors.borderColor, width: 2.5),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: isUser
                ? const Radius.circular(14)
                : const Radius.circular(4),
            bottomRight: isUser
                ? const Radius.circular(4)
                : const Radius.circular(14),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.borderColor,
              offset: isUser ? const Offset(3, 3) : const Offset(-3, 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label pengirim
            Text(
              isUser ? "KAMU" : "BOT",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
                color: isUser
                    ? AppColors.borderColor.withValues(alpha: 0.5)
                    : AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 4),
            // Isi pesan
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.borderColor,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget tampilan kosong saat belum ada pesan
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ikon chatbot dengan border neobrutalism
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.accentBlue,
              border: Border.all(color: AppColors.borderColor, width: 3),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.borderColor,
                  offset: Offset(4, 4),
                  blurRadius: 0,
                ),
              ],
            ),
            child: const Icon(
              Icons.smart_toy_outlined,
              size: 42,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.accentYellow,
              border: Border.all(color: AppColors.borderColor, width: 2),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.borderColor,
                  offset: Offset(3, 3),
                  blurRadius: 0,
                ),
              ],
            ),
            child: const Text(
              "TANYA APA SAJA!",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 14,
                letterSpacing: 1,
                color: AppColors.borderColor,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Ketik pertanyaan tentang\nbank sampah di bawah ↓",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF888888),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // Widget indikator typing bergaya neobrutalism
  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.accentPink.withValues(alpha: 0.3),
        border: Border.all(color: AppColors.borderColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              color: AppColors.borderColor,
              strokeWidth: 2.5,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            "Bot sedang mengetik...",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: AppColors.borderColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Row(
          children: [
            // Mini icon neobrutalism
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.accentBlue,
                border: Border.all(color: AppColors.borderColor, width: 2),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.borderColor,
                    offset: Offset(2, 2),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: const Icon(Icons.smart_toy, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Text(
              "TANYA BOT",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.bgColor,
        foregroundColor: AppColors.borderColor,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(height: 3, color: AppColors.borderColor),
        ),
      ),
      body: Column(
        children: [
          // Area pesan
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isUser = msg['isUser'] as bool;
                      return _buildChatBubble(msg['text'] ?? '', isUser);
                    },
                  ),
          ),

          // Typing indicator
          if (_isTyping) _buildTypingIndicator(),

          // Area input
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.bgColor,
              border: Border(
                top: BorderSide(color: AppColors.borderColor, width: 3),
              ),
            ),
            child: Row(
              children: [
                // Input field neobrutalism
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardColor,
                      border: Border.all(
                        color: AppColors.borderColor,
                        width: 2.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.borderColor,
                          offset: Offset(3, 3),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: AppColors.borderColor,
                      ),
                      decoration: const InputDecoration(
                        hintText: "Ketik pertanyaanmu...",
                        hintStyle: TextStyle(
                          color: Color(0xFFAAAAAA),
                          fontWeight: FontWeight.w600,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Tombol kirim neobrutalism
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      border: Border.all(
                        color: AppColors.borderColor,
                        width: 2.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.borderColor,
                          offset: Offset(3, 3),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
