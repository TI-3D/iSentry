import 'dart:io';
import 'dart:math';
// import 'dart:ui';

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
// import 'package:get_thumbnail_video/index.dart';
// import 'package:get_thumbnail_video/video_thumbnail.dart';
// import 'package:isentry/core/configs/ip_address.dart';
import 'package:isentry/presentation/home/bloc/medias/media_bloc.dart';
import 'package:isentry/presentation/home/bloc/medias/media_event.dart';
import 'package:isentry/presentation/home/bloc/medias/media_state.dart';
import 'package:isentry/presentation/widgets/components/sort.dart';
import 'package:lucide_icons/lucide_icons.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MediaPageState createState() => _MediaPageState();
}

String generateRandomString(int length) => String.fromCharCodes(List.generate(
    length,
    (_) => Random().nextBool()
        ? Random().nextInt(26) + 65
        : Random().nextInt(26) + 97));

class _MediaPageState extends State<MediaPage> {
  // Function to generate thumbnail dynamically using the provided genThumbnail method
  Future<String?> generateThumbnail(String videoPath) async {
    try {
      return null;
//       print("Generating thumbnail for video: $videoPath");
//       final tempDir = await getTemporaryDirectory(); // Temp directory
//       final random = generateRandomString(6);
//       final outputFile = File('${tempDir.path}/$random.jpg');

//       print("Output file path: ${outputFile.path}");

//       final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();

// // Perintah FFmpeg untuk menghasilkan thumbnail dari video
//       final arguments = [
//         '-f', 'mp4',
//         '-i', videoPath, // Input video
//         '-vf', 'thumbnail', // Gunakan filter thumbnail
//         '-ss',
//         '00:00:01', // Waktu pada video untuk mengambil thumbnail (misal 5 detik)
//         '-vframes', '1', // Ambil 1 frame
//         outputFile.path // Output path untuk thumbnail
//       ];

//       // Jalankan perintah untuk menghasilkan thumbnail
//       final statusCode = await _flutterFFmpeg.executeWithArguments(arguments);
//       print("FFmpeg exited with status code $statusCode");

//       return outputFile.path;
    } catch (e) {
      print("Failed to generate thumbnail: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MediaBloc()..add(LoadMedia()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xfff1f4f9),
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: MySort(
              texts: const ['Week', 'Month', 'Year'],
              leftPadding: 25,
              rightPadding: 25,
              // ignore: avoid_types_as_parameter_names
              onItemSelected: (int) {
                0;
              },
            ),
          ),
        ),
        body: BlocBuilder<MediaBloc, MediaState>(
          builder: (context, state) {
            if (state is MediaLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MediaLoaded) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: state.mediaItems.length,
                  itemBuilder: (context, index) {
                    final mediaItem = state.mediaItems[index];
                    final formattedDate = DateFormat("d MMMM yyyy, HH:mm")
                        .format(mediaItem.createdAt);

                    // Using FutureBuilder to load thumbnail dynamically
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          color: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(
                            children: [
                              FutureBuilder<String?>(
                                future: generateThumbnail(mediaItem.path),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return const Center(
                                        child: Icon(Icons.error));
                                  } else if (snapshot.hasData) {
                                    if (snapshot.data != null &&
                                        snapshot.data!.isNotEmpty) {
                                      return Container(
                                        height: 150,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          image: DecorationImage(
                                            image: FileImage(File(snapshot
                                                .data!)), // Use FileImage for local thumbnails
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        height: 150,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: Colors
                                              .black, // Placeholder if no thumbnail
                                        ),
                                      );
                                    }
                                  } else {
                                    return Container(
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors
                                            .black, // Placeholder if no thumbnail
                                      ),
                                    );
                                  }
                                },
                              ),
                              // Play button in the center of the image
                              Positioned.fill(
                                child: Center(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(30),
                                      onTap: () async {
                                        await _launchVideo(mediaItem
                                            .path); 
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Cap${mediaItem.createdAt.month.toString().padLeft(2, '0')}-${mediaItem.createdAt.day.toString().padLeft(2, '0')}-${mediaItem.createdAt.year.toString().substring(2)}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              const Icon(
                                LucideIcons.calendarDays,
                                size: 12,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            } else if (state is MediaError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // Function to open video in the gallery app
  Future<void> _launchVideo(String filePath) async {
    final Uri _videoUri =
        Uri.parse(filePath);
    if (await canLaunchUrl(_videoUri)) {
      await launchUrl(_videoUri,
          mode: LaunchMode
              .externalApplication); 
    } else {
      throw 'Could not launch $filePath'; 
    }
  }
}
