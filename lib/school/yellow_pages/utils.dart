import 'entity/contact.dart';

final _whitespace = RegExp(r'\s*');

List<SchoolDeptContact> matchSchoolContacts(List<SchoolDeptContact> all, String query) {
  query = query.toLowerCase().replaceAll(_whitespace, "");
  final result = <SchoolDeptContact>[];
  for (final dept in all) {
    if (dept.department.replaceAll(_whitespace, "").toLowerCase().contains(query)) {
      result.add(dept);
      continue;
    }
    final contacts = <SchoolContact>[];
    for (final contact in dept.contacts) {
      if (contact.name?.replaceAll(_whitespace, "").toLowerCase().contains(query) ?? false) {
        contacts.add(contact);
      } else if (contact.description?.replaceAll(_whitespace, "").toLowerCase().contains(query) ?? false) {
        contacts.add(contact);
      } else if (contact.phone.contains(query)) {
        contacts.add(contact);
      }
    }
    if (contacts.isNotEmpty) {
      result.add(SchoolDeptContact(department: dept.department, contacts: contacts));
    }
  }
  return result;
}
