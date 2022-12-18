import '../dao/contact.dart';
import '../entity/contact.dart';
import '../using.dart';

class ContactRemoteService implements ContactRemoteDao {
  static const _contactUrl = '/contact';
  final ISession session;

  const ContactRemoteService(this.session);

  @override
  Future<List<ContactData>> getAllContacts() async {
    final response = await session.request(_contactUrl, ReqMethod.get);
    final List contactList = response.data;
    List<ContactData> result = contactList.map((e) => ContactData.fromJson(e)).toList();
    return result;
  }
}
