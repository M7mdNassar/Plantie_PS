import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantie/modules/Home/cubit/cubit.dart';
import 'package:plantie/modules/Home/cubit/states.dart';
import 'package:plantie/modules/Home/fertilizer_screen.dart';
import 'package:plantie/shared/components/components.dart';
import 'package:plantie/shared/styles/colors.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/plant.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {
        },
        builder: (context, state) {
          final cubit = HomeCubit.get(context);
          final plants = cubit.plants;
          final hasPlants = plants.isNotEmpty;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 70.0, 15.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // weather card
                  Container(
                    height: 220,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [Color(0xFF6AA6FF), Color(0xFFBFDFFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // left column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Partly Cloudy',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Icon(Icons.wb_sunny, color: Colors.yellow, size: 120),
                          ],
                        ),

                        // middle divider (the vertical line)
                        Container(
                          width: 1,
                          height: 150,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),

                        // right column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'New York, USA',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Monday',
                              style: TextStyle(fontSize: 16, color: Colors.white70),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              '22°',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '77.7 F°',
                              style: TextStyle(fontSize: 18, color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Weather",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Text(
                    "Weather today is good day .....Weather today is good day .....",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Choose a Plant",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  SizedBox(
                    height: 130,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder:(context , index) => buildPlantItem(index , cubit),
                      itemCount: 10,
                      separatorBuilder: (context , index) => SizedBox(
                        width: 18,
                      ) ,
                    ),
                  ),

                  if (hasPlants) Text(
                    plants[cubit.selectedIndex].name,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  SizedBox(height: 15),

                  Container(
                    width: double.infinity,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: plantieColor, // Light green color
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: TextButton(
                      onPressed: () {
                        navigateTo(context, FertilizerScreen());
                      },
                      child: Text(
                        "Calculate Fertilizer",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),


                  if (!hasPlants)
                    _buildLoadingShimmer()
                  else
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildPlantDetailCard(context, plants[cubit.selectedIndex]),
                        const SizedBox(height: 20),
                        _buildDetailTabs(context, plants[cubit.selectedIndex]),
                      ],
                    ),
                ],
              ),
            ),
          );
        });
  }

  Widget buildPlantItem(int index , cubit) {
    bool isSelected = index == cubit.selectedIndex;

    return GestureDetector(
      onTap: () {
        cubit.changeSelectedIndex(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(
            cubit.plantEmojis[index],
            style: TextStyle(
              fontSize: 65,
            ),
          ),

          const SizedBox(height: 5),
          if (isSelected)
            Container(
              width: 50,
              height: 2,
              color: plantieColor, // Underline for the selected plant
            ),
        ],
      ),
    );
  }




  Widget _buildLoadingShimmer() {
    return Column(
      children: List.generate(3, (index) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      )),
    );
  }

  Widget _buildPlantDetailCard(BuildContext context, Plant plant) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plant.category,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: plantieColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        plant.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 80,
                    height: 80,
                    alignment: Alignment.center,
                    child: Text(
                      HomeCubit.get(context).plantEmojis[HomeCubit.get(context).selectedIndex],
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.calendar_today, 'Planting Time', plant.plantingTime),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.eco, 'NPK Formula', plant.npk),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTabs(BuildContext context, Plant plant) {
    return DefaultTabController(
      length: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabBar(
            isScrollable: true,
            labelColor: plantieColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: plantieColor,
            tabs: const [
              Tab(text: 'Description'),
              Tab(text: 'Nutrition'),
              Tab(text: 'Storage'),
              Tab(text: 'Diseases'),
            ],
          ),
          SizedBox(
            height: 300,
            child: TabBarView(
              children: [
                _buildTabContent(Icons.description, plant.description),
                _buildNutritionContent(plant.nutritionRecommendations),
                _buildStorageContent(plant.storageInfo),
                _buildDiseaseContent(plant.diseaseAndPestControl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align items to the top for multi-line text
        children: [
          Icon(icon, color: plantieColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black, fontSize: 14),
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTabContent(IconData icon, String content) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: plantieColor, size: 32),
          const SizedBox(height: 16),
          Text(
            content,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionContent(Map<String, String> nutrition) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: nutrition.entries.map((entry) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                entry.key,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(entry.value),
            ),
          ],
        ),
      )).toList(),
    );
  }

  Widget _buildStorageContent(Map<String, String> storage) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildStorageItem('Temperature', storage['temperature']!),
        _buildStorageItem('Humidity', storage['humidity']!),
      ],
    );
  }

  Widget _buildStorageItem(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading:  Icon(Icons.storage, color: plantieColor),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }

  Widget _buildDiseaseContent(List<Disease> diseases) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: diseases.length,
      itemBuilder: (context, index) => Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ExpansionTile(
          leading:  Icon(Icons.health_and_safety, color: plantieColor),
          title: Text(diseases[index].name),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prevention:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(diseases[index].prevention),
                  const SizedBox(height: 16),
                  Image.asset(
                    // 'assets/${diseases[index].imageURL}',
                    'assets/images/user.png',
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
