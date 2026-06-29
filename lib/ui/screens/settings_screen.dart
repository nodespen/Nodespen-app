import 'package:flutter/material.dart';
import '../../services/colab_service.dart';
import '../../services/ai_service.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  final ColabService? colabService;
  final AiService? aiService;

  const SettingsScreen({super.key, this.colabService, this.aiService});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _onionSkinDefault = false;
  bool _autoTween = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NodespenColors.background,
      appBar: AppBar(
        title: const Text('Ajustes', style: TextStyle(color: NodespenColors.textPrimary, fontSize: 16)),
        backgroundColor: NodespenColors.surface,
        iconTheme: const IconThemeData(color: NodespenColors.textSecondary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section('Animación'),
          _switchTile('Auto-Tween', 'Interpolar automáticamente entre keyframes', _autoTween, (v) => setState(() => _autoTween = v)),
          _switchTile('Onion Skin por defecto', 'Mostrar piel de cebolla al abrir', _onionSkinDefault, (v) => setState(() => _onionSkinDefault = v)),
          const SizedBox(height: 16),
          _section('Colaboración'),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Nombre de usuario',
              labelStyle: TextStyle(color: NodespenColors.textSecondary, fontSize: 12),
              border: OutlineInputBorder(borderSide: BorderSide(color: NodespenColors.border)),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            style: const TextStyle(color: NodespenColors.textPrimary, fontSize: 13),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Colab Mode conectado (simulado)', style: TextStyle(color: Colors.white))),
              );
            },
            icon: const Icon(Icons.group_add, size: 16),
            label: const Text('Iniciar sesión Colab', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: NodespenColors.accent,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _section('AI Assist'),
          TextField(
            decoration: const InputDecoration(
              labelText: 'API Key (opcional)',
              labelStyle: TextStyle(color: NodespenColors.textSecondary, fontSize: 12),
              border: OutlineInputBorder(borderSide: BorderSide(color: NodespenColors.border)),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            style: const TextStyle(color: NodespenColors.textPrimary, fontSize: 13),
            obscureText: true,
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('AI Assist configurado (simulado)', style: TextStyle(color: Colors.white))),
              );
            },
            icon: const Icon(Icons.auto_awesome, size: 16),
            label: const Text('Conectar AI', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: NodespenColors.primary,
              foregroundColor: NodespenColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          _section('Acerca de'),
          _aboutTile('Nodespen', 'v0.1.0'),
          _aboutTile('Desarrollado para', 'Animación 2D multiplataforma'),
          _aboutTile('Modos', 'Dibujo • Nodo • Gacha'),
          _aboutTile('Stack', 'Flutter • Dart • CustomPainter'),
        ],
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Text(title, style: const TextStyle(
        color: NodespenColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1,
      )),
    );
  }

  Widget _switchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Card(
      color: NodespenColors.surface,
      margin: const EdgeInsets.only(bottom: 4),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(color: NodespenColors.textPrimary, fontSize: 13)),
        subtitle: Text(subtitle, style: const TextStyle(color: NodespenColors.textSecondary, fontSize: 11)),
        value: value,
        onChanged: onChanged,
        activeColor: NodespenColors.accent,
      ),
    );
  }

  Widget _aboutTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: NodespenColors.textSecondary, fontSize: 12)),
          Text(value, style: const TextStyle(color: NodespenColors.textPrimary, fontSize: 12)),
        ],
      ),
    );
  }
}
