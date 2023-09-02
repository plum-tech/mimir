import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rettulf/rettulf.dart';

import '../init.dart';
import '../service/email.dart';
import '../using.dart';
import 'item.dart';

class MailPage extends StatefulWidget {
  const MailPage({super.key});

  @override
  State<StatefulWidget> createState() => _MailPageState();
}

class _MailPageState extends State<MailPage> {
  static const indexEmailList = 0;
  static const indexErrorPage = 1;
  int _index = indexEmailList; // 0 - 邮件列表, 1 - 错误页.
  List<MimeMessage>? _messages;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final oaCredential = context.auth.oaCredential;
    if (oaCredential != null) {
      _updateMailList(oaCredential);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final oaCredential = context.auth.oaCredential;
    final String title;
    if (oaCredential != null) {
      title = oaCredential.account.toEmailAddress();
    } else {
      title = i18n.title;
    }
    return Scaffold(
      appBar: AppBar(
        title: title.text(),
      ),
      body: _buildBody(context),
    );
  }

  Future<void> _updateMailList(OACredential oaCredential) async {
    try {
      final String emailAddress = oaCredential.account.toEmailAddress();
      final String pwd = EduEmailInit.mail.password ?? oaCredential.password;
      final messages = (await _loadMailList(emailAddress, pwd)).messages;
      // 日期越大的越靠前
      messages.sort((a, b) {
        return a.decodeDate()!.isAfter(b.decodeDate()!) ? -1 : 1;
      });
      if (!mounted) return;
      setState(() => _messages = messages);
    } catch (_) {
      if (!mounted) return;
      setState(() => _index = 1);
    }
  }

  Future<FetchImapResult> _loadMailList(String emailAddress, String pwd) async {
    final service = MailService(emailAddress, pwd);

    return await service.getInboxMessage(30);
  }

  Widget _buildMailList() {
    final List<Widget> items = _messages!.map((e) {
      return Column(
        children: [
          MailItem(e),
          const Divider(),
        ],
      );
    }).toList();
    return ListView(children: items);
  }

  Widget _buildPwdInputBoxWhenFailed() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 0.75.sw),
            /**
             * TODO: Email password?
             * "eduEmailLoginFailTip": "Failed to log in your edu email with OA Password. Troubleshooting:\n1.If you've never changed it, try all passwords you ever used.\n2."
             */
            child: Text(
              '登录失败，无法使用 OA 密码登录你的账户。\n'
              '这可能是信息中心未同步你的邮箱密码导致的。如果你未重置过该密码，它可能是你任意一次设置的 OA 密码。',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Row(mainAxisSize: MainAxisSize.min, children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 0.6.sw),
              child: TextField(
                  controller: _controller, decoration: const InputDecoration(hintText: '密码'), obscureText: true),
            ),
            ElevatedButton(
                onPressed: () {
                  EduEmailInit.mail.password = _controller.text;
                  setState(() => _index = indexEmailList);
                },
                child: i18n.continue$.text())
          ]),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    // 如果当前加载邮件列表
    if (_index == 0) {
      // 如果是首次加载, 拉取数据并显示加载动画
      if (_messages == null) {
        return Placeholders.loading();
      }
      // 非首次加载, 即已获取邮件列表, 直接渲染即可
      return _buildMailList();
    } else {
      // _index == 1, 显示密码输入页
      return _buildPwdInputBoxWhenFailed();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

extension _EmailAddressEx on String {
  String toEmailAddress() => "$this@mail.sit.edu.cn";
}
