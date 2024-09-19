import 'package:enough_mail/enough_mail.dart';
import 'package:mimir/credentials/entity/credential.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/settings/meta.dart';

import '../entity/email.dart';
import 'email.dart';

class DemoMailService implements MailService {
  @override
  Future<void> login(Credential credential) async {
    return;
  }

  @override
  Future<List<MailEntity>> getInboxEmails({int count = 50}) async {
    final start = Meta.thisLaunchTime ?? DateTime.now();
    final recipients = [
      MailAddress(
        "You",
        CredentialsInit.storage.eduEmail.credentials?.account ?? "2300421153@mail.sit.edu.cn",
      )
    ];
    MailEntity gen({
      required String sender,
      required String subject,
      required String content,
      int dayDelta = -7,
    }) {
      return MailEntity(
        subject: subject,
        senders: [MailAddress(sender, "liplum@liplum.net")],
        recipients: recipients,
        date: start.copyWith(day: start.day + dayDelta),
        plaintext: content,
        html: content,
        htmlDarkMode: content,
      );
    }

    await Future.delayed(const Duration(milliseconds: 300));
    return [
      gen(
        dayDelta: -5,
        sender: "Liplum",
        subject: "感谢您支持小应生活",
        content: """
作为小应生活的开发者代表，我向您表达诚挚的感谢！感谢您在过去的这段时间里对小应生活app的支持。您的每一次使用，每一次反馈，都为我们产品的改进提供了宝贵的建议。正是有了您的支持，我们才能不断迭代，推出更符合您需求的新版本。
我们已经根据您的建议对课程表功能进行了优化，相信能给您带来更好的使用感受。未来，我们将继续努力，开发更多实用、有趣的功能，让小应生活app成为您校园生活中不可或缺的助手。敬请期待！
为了感谢您的支持，我们即将推出“校园生活分享大赛”活动，欢迎您积极参与，分享您的校园故事。您的精彩分享将有机会获得丰厚的奖品。
祝您在未来的学习生活中一切顺利！小应生活app将一直陪伴在您的身边。
"""
            .replaceAll("\n", " "),
      ),
      gen(
        dayDelta: -7,
        sender: "小应生活",
        subject: "欢迎使用小应生活app",
        content: """
欢迎使用小应生活app！感谢您选择我们，您的支持是我们不断前进的动力。
我们注意到您最近对课程表特别感兴趣，很高兴能为您提供这项服务。小应生活app为您提供一站式生活服务，旨在让您的校园生活更加便捷、智能。
如果在使用过程中遇到任何问题，欢迎随时联系我们的客服团队，我们将竭诚为您服务。
此外，我们还邀请您加入我们的用户社区，与其他用户分享您的使用心得。您的宝贵建议将帮助我们更好地改进产品。
祝您使用愉快！
小应生活app团队
"""
            .replaceAll("\n", " "),
      ),
    ];
  }
}
