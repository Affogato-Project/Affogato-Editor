part of affogato.editor;

/// A widget that is to be placed inside an [EditorPane] needs to subclass this class.
/// Note that this widget will only rebuild when any of the five properties, [instanceId],
/// [editorTheme], [workspaceConfigs], [extensionsEngine], or [width] change, and never
/// otherwise. In order to force a rebuild, define listeners on the various streams of [AffogatoEvents] in the
/// the associated State object's [State.initState], and call [State.setState] from there.
///
/// Subclasses should also refrain from defining additional parameters in their constructors and then accessing them
/// via [State.widget]. These parameters should be extracted out into a separate [PaneInstanceData] class. Ideally, subclasses
/// can be instantiated without any class-specific arguments having to be passed, and they will then obtain their data through the
/// [AffogatoWorkspaceConfigs.instancesData] during the [State.initState]. This is achieved by mixing in the [PaneInstanceStateManager] on
/// [State] objects for [PaneInstance]s. The instantiator is responsible for ensuring that
/// an entry for the given [instanceId] exists in the workspace configs.
abstract class PaneInstance<T extends PaneInstanceData> extends StatefulWidget {
  final String instanceId;
  final String paneId;
  final EditorTheme<Color, TextStyle> editorTheme;
  final AffogatoWorkspaceConfigs workspaceConfigs;
  final AffogatoExtensionsEngine extensionsEngine;
  final LayoutConfigs layoutConfigs;
  final AffogatoAPI api;

  PaneInstance({
    required this.api,
    required this.editorTheme,
    required this.workspaceConfigs,
    required this.extensionsEngine,
    required this.paneId,
    required this.instanceId,
    required this.layoutConfigs,
  }) : super(
          key: ValueKey(
            "$instanceId${editorTheme.hashCode}${workspaceConfigs.hashCode}${extensionsEngine.hashCode}$layoutConfigs",
          ),
        );
}

/// For [State] objects of [PaneInstance]s. Call [getData] from [initState], and also
/// whenever the [data] object needs to be updated.
mixin PaneInstanceStateManager<T extends PaneInstanceData>
    on State<PaneInstance<T>> {
  late T data;

  void getData({
    T Function()? onNull,
    T Function(PaneInstanceData?)? onWrongDataType,
  }) {
    final givenData =
        (widget.workspaceConfigs.instancesData[widget.instanceId] ??
            onNull?.call());
    if (givenData is T) {
      data = givenData;
    } else {
      data = onWrongDataType?.call(givenData) ??
          (throw Exception(
              "Data of type '$T' expected, but '${givenData.runtimeType}' was found in workspace configuration."));
    }
  }
}
