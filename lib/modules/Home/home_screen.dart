import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantie/modules/Home/cubit/cubit.dart';
import 'package:plantie/modules/Home/cubit/states.dart';
import 'package:plantie/modules/Home/fertilizer_screen.dart';
import 'package:plantie/shared/components/components.dart';
import 'package:plantie/shared/styles/colors.dart';


class HomeScreen extends StatelessWidget {
    const HomeScreen({super.key});

   @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {
          if (state is HomeGetPlantsSuccessState){

          }
        },
        builder: (context, state) {
          final cubit = HomeCubit.get(context);
          var plant = cubit.plants[cubit.selectedIndex];

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
                      itemCount: cubit.plantEmojis.length,
                      separatorBuilder: (context , index) => SizedBox(
                        width: 18,
                      ) ,
                    ),
                  ),

                  Text(
                    plant.name,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  SizedBox(
                    height: 15,
                  ),

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


                  // complete design here ...

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

}
