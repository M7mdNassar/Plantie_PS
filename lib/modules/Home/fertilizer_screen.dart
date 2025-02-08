import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:plantie/shared/styles/colors.dart';
import '../../layout/cubit/cubit.dart';

class PlantData {
  final String name;
  final String type; // 'tree' or 'crop'
  final String npk;
  final String emoji;

  PlantData({
    required this.name,
    required this.type,
    required this.npk,
    required this.emoji,
  });
}

class FertilizerScreen extends StatefulWidget {
  final PlantData plant;

  const FertilizerScreen({super.key, required this.plant});

  @override
  _FertilizerScreenState createState() => _FertilizerScreenState();
}

class _FertilizerScreenState extends State<FertilizerScreen> {
  double landArea = 1.0;
  int treeCount = 1;
  int treeAge = 1;
  Map<String, double>? fertilizerAmounts;
  String selectedUnit = 'Dunam';
  final List<String> units = ['Dunam', 'Acre'];
  String? calculationType;


  void calculateFertilizer() {
    final npkValues = widget.plant.npk.split('-').map(double.parse).toList();

    double baseCalculation;
    String newCalculationType;

    if (widget.plant.type == 'أشجار') {
      double ageFactor = _calculateAgeFactor();
      baseCalculation = treeCount * ageFactor;
      newCalculationType = 'per tree';
    } else {
      double areaInDunams = selectedUnit == 'Acre' ? landArea * 4.046 : landArea;
      baseCalculation = areaInDunams;
      newCalculationType = 'per $selectedUnit';
    }

    const ureaPercent = 46;
    const sspPercent = 16;
    const mopPercent = 60;

    final requiredN = npkValues[0] * baseCalculation;
    final requiredP = npkValues[1] * baseCalculation;
    final requiredK = npkValues[2] * baseCalculation;

    final urea = (requiredN / ureaPercent) * 100;
    final ssp = (requiredP / sspPercent) * 100;
    final mop = (requiredK / mopPercent) * 100;

    setState(() {
      fertilizerAmounts = {
        'SSP': ssp,
        'UREA': urea,
        'MOP': mop,
      };
      calculationType = newCalculationType;
    });
  }

  double _calculateAgeFactor() {
    if (treeAge < 3) return 0.5;
    if (treeAge <= 10) return 1.0;
    return 1.2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.plant.emoji} ${widget.plant.name} Fertilizer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPlantHeader(),
            const SizedBox(height: 20),
            _buildNpkDisplay(),
            const SizedBox(height: 20),
            if (widget.plant.type == 'أشجار' || widget.plant.type == 'فواكه')
              _buildTreeInputs()
            else
              _buildLandAreaControl(),
            const SizedBox(height: 30),
            _buildCalculateButton(),
            const SizedBox(height: 30),
            if (fertilizerAmounts != null) _buildResultsCard(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildPlantHeader() {
    return Card(
      color: AppCubit.get(context).isDark
          ? HexColor("1C1C1E")
          : HexColor("FFFFFF"),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(widget.plant.emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.plant.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Type: ${widget.plant.type.toUpperCase()}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreeInputs() {
    return Column(
      children: [
        _buildCounterInput(
          label: 'Number of Trees',
          value: treeCount,
          onDecrement: () => setState(() => treeCount = treeCount > 1 ? treeCount - 1 : 1),
          onIncrement: () => setState(() => treeCount++),
        ),
        const SizedBox(height: 20),
        _buildCounterInput(
          label: 'Tree Age (Years)',
          value: treeAge,
          onDecrement: () => setState(() => treeAge = treeAge > 1 ? treeAge - 1 : 1),
          onIncrement: () => setState(() => treeAge++),
        ),
      ],
    );
  }

  Widget _buildLandAreaControl() {
    return Card(
      color: AppCubit.get(context).isDark
          ? HexColor("1C1C1E")
          : HexColor("FFFFFF"),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Land Area ($selectedUnit):',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red, size: 32),
                    onPressed: () => setState(() {
                      if (landArea > 0.5) landArea -= 0.5;
                    }),
                  ),
                  Text(
                    '$landArea',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.green, size: 32),
                    onPressed: () => setState(() => landArea += 0.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _buildUnitSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterInput({
    required String label,
    required int value,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Card(
      color: AppCubit.get(context).isDark
          ? HexColor("1C1C1E")
          : HexColor("FFFFFF"),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, color: Colors.red),
                  onPressed: onDecrement,
                ),
                Text(
                  '$value',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.green),
                  onPressed: onIncrement,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitSelector() {
    return Row(
      children: [
        const Text('Unit:'),
        const SizedBox(width: 10),
        ...units.map((unit) => ChoiceChip(
          label: Text(unit , style: Theme.of(context).textTheme.bodyMedium,),
          selected: selectedUnit == unit,
          onSelected: (selected) => setState(() => selectedUnit = unit),
        )).toList(),
      ],
    );
  }

  Widget _buildNpkDisplay() {
    return Card(
      color: AppCubit.get(context).isDark
          ? HexColor("1C1C1E")
          : HexColor("FFFFFF"),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Recommended NPK Ratio:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widget.plant.npk.split('-').asMap().entries.map((entry) {
                return Column(
                  children: [
                    Text(
                      entry.value,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    Text(
                      ['Nitrogen', 'Phosphorus', 'Potassium'][entry.key],
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculateButton() {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.calculate, color: Colors.white),
        label: const Text(
          'Calculate Requirements',
          style: TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          backgroundColor: plantieColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: calculateFertilizer,
      ),
    );
  }

  Widget _buildResultsCard() {
    final isTree = widget.plant.type == 'tree';

    return Card(
      color: AppCubit.get(context).isDark
          ? HexColor("1C1C1E")
          : HexColor("FFFFFF"),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Required Fertilizers (${isTree ? 'for $treeCount trees' : calculationType}):',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFertilizerTile('SSP', fertilizerAmounts!['SSP']!),
                _buildFertilizerTile('UREA', fertilizerAmounts!['UREA']!),
                _buildFertilizerTile('MOP', fertilizerAmounts!['MOP']!),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              isTree
                  ? 'Note: Calculations include age factor for ${treeAge} year old trees'
                  : 'Note: 1 Dunam = 1000 m² (10,000 sq ft)',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFertilizerTile(String type, double amount) {
    return Column(
      children: [
        if (type == "SSP")
          Text('🌱', style: TextStyle(fontSize: 50)),
        if (type == "UREA")
          Text('🍃', style: TextStyle(fontSize: 50)),
        if (type == "MOP")
          Text('🌸', style: TextStyle(fontSize: 50)),
        const SizedBox(height: 8),
        Text(
          '${amount.toStringAsFixed(1)} kg',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          type,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}