import '../dao/contact.dart';
import '../entity/contact.dart';
import '../using.dart';

class ContactDataStorage implements ContactStorageDao {
  final Box<ContactData> box;

  const ContactDataStorage(this.box);

  @override
  void add(ContactData data) {
    box.add(data);
  }

  @override
  List<ContactData> getAllContacts() {
    var result = box.values.toList();
    result.sort((a, b) => a.department.compareTo(b.department));
    return result;
  }

  @override
  void addAll(List<ContactData> data) {
    box.addAll(data);
  }

  @override
  void clear() {
    box.clear();
  }
}
