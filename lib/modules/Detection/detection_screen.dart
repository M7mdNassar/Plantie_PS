import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantie/modules/Detection/cubit/cubit.dart';
import 'package:plantie/modules/Detection/cubit/states.dart';
import '../../models/history_item.dart';
import '../../shared/components/components.dart';
import 'history_details_screen.dart';

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

  // Add this missing method
  Widget _buildMainContent(
      BuildContext context, DetectionCubit cubit, DetectionStates state) {
    if (state is DetectionLoadingState) {
      return const Center(child: CircularProgressIndicator());
    }

    if (cubit.currentImage == null) {
      return SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildHistorySection(context),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildImagePreview(cubit.currentImage!),
          const SizedBox(height: 24),
          _buildDetectionResult(cubit.currentResult!),
          const SizedBox(height: 32),
          _buildHistorySection(context),
        ],
      ),
    );
  }

  // Add these missing UI components
  Widget _buildImagePreview(File file) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.file(
        file,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildDetectionResult(String result) {
    return Card(
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              result,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
            const Divider(height: 32),
            Text(
              'Recommended Treatment',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'None',
              style: TextStyle(fontSize: 16, color: Colors.grey),
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
        _buildHistoryList(context),
      ],
    );
  }

  Widget _buildHistoryList(BuildContext context) {
    final cubit = DetectionCubit.get(context);

    if (cubit.history.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text('No history available'),
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
          background: Container(color: Colors.red),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Confirm Delete'),
                content:
                    const Text('Are you sure you want to delete this item?'),
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

            if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.existsSync()) {
              log('Missing image at path: ${item.imagePath}');
              return _buildImagePlaceholder();
            }
            return _buildImagePreview(snapshot.data!);
          },
        ),
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text('Treatment: ${item.treatment}'),
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
