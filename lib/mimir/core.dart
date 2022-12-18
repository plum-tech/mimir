part of 'mimir.dart';

abstract class Mimir with ConverterMixin, _MimirDebugOptionsImpl {}

class _MimirImpl extends Mimir {
  _MimirImpl();
}

typedef IMimirPlugin = void Function(Mimir mimir);

extension IKitePluginEx on Mimir {
  void install(IMimirPlugin plugin) {
    plugin(this);
  }

  void installAll(List<IMimirPlugin> plugins) {
    for (final plugin in plugins) {
      install(plugin);
    }
  }
}
