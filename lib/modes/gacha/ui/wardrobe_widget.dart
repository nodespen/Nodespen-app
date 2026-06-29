import 'package:flutter/material.dart';
import '../models/gacha_character.dart';
import '../models/clothing_item.dart';

class WardrobeWidget extends StatelessWidget {
  final GachaCharacter character;
  final void Function(ClothingItem)? onEquip;
  final void Function(ClothingCategory)? onUnequip;

  const WardrobeWidget({
    super.key,
    required this.character,
    this.onEquip,
    this.onUnequip,
  });

  static const _categories = ClothingCategory.values;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      color: const Color(0xFF2A2A2A),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Vestuario',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const Divider(color: Colors.white24, height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: _categories.length,
              itemBuilder: (ctx, i) => _CategoryTile(
                category: _categories[i],
                equipped: character.getEquipped(_categories[i]),
                inventory: character.inventory,
                onEquip: onEquip,
                onUnequip: onUnequip,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final ClothingCategory category;
  final ClothingItem? equipped;
  final List<ClothingItem> inventory;
  final void Function(ClothingItem)? onEquip;
  final void Function(ClothingCategory)? onUnequip;

  const _CategoryTile({
    required this.category,
    this.equipped,
    required this.inventory,
    this.onEquip,
    this.onUnequip,
  });

  @override
  Widget build(BuildContext context) {
    final items = inventory.where((item) => item.category == category).toList();
    if (items.isEmpty) return const SizedBox.shrink();

    return ExpansionTile(
      initiallyExpanded: equipped != null,
      tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      title: Row(
        children: [
          _categoryIcon(category),
          const SizedBox(width: 8),
          Text(_categoryName(category),
              style: const TextStyle(color: Colors.white, fontSize: 13)),
          if (equipped != null) ...[
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                color: equipped!.color.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(equipped!.name,
                  style: const TextStyle(color: Colors.white70, fontSize: 10)),
            ),
          ],
        ],
      ),
      children: [
        if (equipped != null)
          ListTile(
            dense: true,
            leading: const Icon(Icons.remove_circle_outline,
                color: Colors.redAccent, size: 18),
            title: const Text('Quitar',
                style: TextStyle(color: Colors.redAccent, fontSize: 12)),
            onTap: () => onUnequip?.call(category),
          ),
        ...items.map((item) => ListTile(
              dense: true,
              leading: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: item.color,
                  border: Border.all(color: Colors.white24),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              title: Text(item.name,
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
              trailing: equipped?.id == item.id
                  ? const Icon(Icons.check, color: Colors.greenAccent, size: 16)
                  : null,
              onTap: () => onEquip?.call(item),
            )),
      ],
    );
  }

  Widget _categoryIcon(ClothingCategory c) {
    IconData icon;
    switch (c) {
      case ClothingCategory.peinado: icon = Icons.face;
      case ClothingCategory.sombrero: icon = Icons.workspace_premium;
      case ClothingCategory.ojos: icon = Icons.visibility;
      case ClothingCategory.boca: icon = Icons.emoji_emotions;
      case ClothingCategory.mascara: icon = Icons.theater_comedy;
      case ClothingCategory.camisa: icon = Icons.checkroom;
      case ClothingCategory.chaqueta: icon = Icons.checkroom;
      case ClothingCategory.vestido: icon = Icons.woman;
      case ClothingCategory.abrigo: icon = Icons.co_present;
      case ClothingCategory.pantalon: icon = Icons.accessibility_new;
      case ClothingCategory.falda: icon = Icons.woman;
      case ClothingCategory.zapatos: icon = Icons.shopping_bag;
      case ClothingCategory.calcetines: icon = Icons.shopping_bag;
      case ClothingCategory.accesorioCabeza: icon = Icons.face_retouching_natural;
      case ClothingCategory.accesorioCuello: icon = Icons.face_retouching_natural;
      case ClothingCategory.accesorioMuneca: icon = Icons.watch;
      case ClothingCategory.ala: icon = Icons.auto_awesome;
      case ClothingCategory.cola: icon = Icons.auto_awesome;
      case ClothingCategory.prop: icon = Icons.star;
    }
    return Icon(icon, color: Colors.white70, size: 18);
  }

  String _categoryName(ClothingCategory c) {
    switch (c) {
      case ClothingCategory.peinado: return 'Peinado';
      case ClothingCategory.sombrero: return 'Sombrero';
      case ClothingCategory.ojos: return 'Ojos';
      case ClothingCategory.boca: return 'Boca';
      case ClothingCategory.mascara: return 'Máscara';
      case ClothingCategory.camisa: return 'Camisa';
      case ClothingCategory.chaqueta: return 'Chaqueta';
      case ClothingCategory.vestido: return 'Vestido';
      case ClothingCategory.abrigo: return 'Abrigo';
      case ClothingCategory.pantalon: return 'Pantalón';
      case ClothingCategory.falda: return 'Falda';
      case ClothingCategory.zapatos: return 'Zapatos';
      case ClothingCategory.calcetines: return 'Calcetines';
      case ClothingCategory.accesorioCabeza: return 'Acc. Cabeza';
      case ClothingCategory.accesorioCuello: return 'Collar';
      case ClothingCategory.accesorioMuneca: return 'Pulsera';
      case ClothingCategory.ala: return 'Alas';
      case ClothingCategory.cola: return 'Cola';
      case ClothingCategory.prop: return 'Accesorio';
    }
  }
}
