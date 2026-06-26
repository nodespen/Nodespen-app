import 'package:flutter/material.dart';
import '../../modes/mode_manager.dart';
import '../../modes/mode.dart';
import '../../core/document/document.dart';
import '../theme/app_theme.dart';

class ModeSelector extends StatelessWidget {
  final ModeManager modeManager;

  const ModeSelector({super.key, required this.modeManager});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: NodespenColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: NodespenColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: modeManager.allModes.map((mode) {
          final isActive = modeManager.activeMode?.modeType == mode.modeType;
          return _ModeButton(
            mode: mode,
            isActive: isActive,
            onTap: () => modeManager.switchTo(mode.modeType),
          );
        }).toList(),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final Mode mode;
  final bool isActive;
  final VoidCallback onTap;

  const _ModeButton({
    required this.mode,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color modeColor;
    switch (mode.modeType) {
      case ProjectMode.draw:
        modeColor = NodespenColors.drawMode;
      case ProjectMode.node:
        modeColor = NodespenColors.nodeMode;
      case ProjectMode.gacha:
        modeColor = NodespenColors.gachaMode;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? modeColor.withValues(alpha: 0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isActive
            ? Border.all(color: modeColor, width: 1.5)
            : Border.all(color: Colors.transparent),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(mode.icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              mode.name,
              style: TextStyle(
                color: isActive ? modeColor : NodespenColors.textSecondary,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
