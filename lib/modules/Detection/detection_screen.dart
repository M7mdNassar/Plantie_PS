import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:plantie/models/disease_info.dart';
import 'package:plantie/modules/Detection/cubit/cubit.dart';
import 'package:plantie/modules/Detection/cubit/states.dart';
import '../../layout/cubit/cubit.dart';
import '../../models/history_item.dart';
import '../../shared/components/components.dart';
import 'history_details_screen.dart';
import 'lottie_arrow.dart';

class DetectionScreen extends StatelessWidget {
  const DetectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DetectionCubit, DetectionStates>(
      listener: (context, state) {
        if (state is DetectionErrorState) {
          showToast(text: state.message, state: ToastStates.error);
        }
      },
      builder: (context, state) {
        final cubit = DetectionCubit.get(context);

        return Scaffold(
          appBar: AppBar(title: const Text('Detection Results')),
          body: _buildMainContent(context, cubit, state),
        );
      },
    );
  }

  Widget _buildMainContent(
      BuildContext context, DetectionCubit cubit, DetectionStates state) {
    if (state is DetectionLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        // Main scroll content
        _buildScrollContent(context, cubit),

        // Overlay elements
        if (cubit.currentImage == null) const LottieArrow(),
      ],
    );
  }

  Widget _buildScrollContent(BuildContext context, DetectionCubit cubit) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (cubit.currentImage != null) ...[
              _buildImagePreview(cubit.currentImage!),
              const SizedBox(height: 24),
              _buildDetectionResult(cubit.orginalResult! , context),
              const SizedBox(height: 32),
            ],
            _buildHistorySection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(File file) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.file(
        file,
        // height: 200,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildDetectionResult(String result , context) {
    final Map<String, DiseaseData> data = DiseaseInfo.data;

    return Card(
      color: AppCubit.get(context).isDark
          ? HexColor("1C1C1E")
          : HexColor("FFFFFF"),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detection Result',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              DiseaseInfo.data[result]!.name,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const Divider(height: 32),
            Text(
              'Recommended Treatment',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              data[result]!.treatment,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            'History',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        _buildHistoryList(context),
      ],
    );
  }

  Widget _buildHistoryList(BuildContext context) {
    final cubit = DetectionCubit.get(context);

    if (cubit.history.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.history, size: 80, color: Colors.grey),
              const SizedBox(height: 24),
              Text(
                'No Detection History',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Your plant health scans will appear here',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cubit.history.length,
      itemBuilder: (context, index) {
        final item = cubit.history[index];
        return Dismissible(
          key: Key(item.id.toString()),
          background: Container( color: Colors.red ,),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,

              builder: (ctx) => AlertDialog(
                backgroundColor: AppCubit.get(context).isDark
                  ? HexColor("1C1C1E")
                  : HexColor("FFFFFF"),
                title:  Text('Confirm Delete' , style: Theme.of(ctx).textTheme.labelLarge,),
                content:
                     Text('Are you sure you want to delete this item?' , style: Theme.of(ctx).textTheme.bodyMedium,),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Delete',
                        style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            cubit.deleteHistoryItem(item.id, item.imagePath);
          },
          child: _buildHistoryItem(context, item),
        );
      },
    );
  }

  Widget _buildHistoryItem(BuildContext context, HistoryItem item) {
    return Card(
      color: AppCubit.get(context).isDark
          ? HexColor("1C1C1E")
          : HexColor("FFFFFF"),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: FutureBuilder<File>(
          future: _checkFileExists(item.imagePath),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildImagePlaceholder();
            }

            if (snapshot.hasError ||
                !snapshot.hasData ||
                !snapshot.data!.existsSync()) {
              log('Missing image at path: ${item.imagePath}');
              return _buildImagePlaceholder();
            }
            return _buildImagePreview(snapshot.data!);
          },
        ),
        title: Text(
          item.title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontSize: 20
          ),
        ),
        subtitle: Text('Treatment: ${item.treatment}' , style: Theme.of(context).textTheme.bodyMedium,),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => navigateTo(context, HistoryDetailScreen(item: item)),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Icon(Icons.photo, color: Colors.grey),
    );
  }

  Future<File> _checkFileExists(String path) async {
    final file = File(path);
    if (await file.exists()) {
      return file;
    }
    return file;
  }
}
