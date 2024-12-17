import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/presentation/home/bloc/medias/media_bloc.dart';
import 'package:isentry/presentation/home/bloc/medias/media_event.dart';
import 'package:isentry/presentation/home/bloc/medias/media_state.dart';
import 'package:isentry/presentation/widgets/components/sort.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart'; // Impor url_launcher

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MediaPageState createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
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
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: NetworkImage(mediaItem
                                        .path), // Path video atau thumbnail
                                    fit: BoxFit.cover,
                                  ),
                                ),
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
                                            .path); // Fungsi untuk membuka video di galeri
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
                                '${mediaItem.createdAt.day.toString().padLeft(2, '0')} ${_monthName(mediaItem.createdAt.month)} ${mediaItem.createdAt.year}, ${mediaItem.createdAt.hour.toString().padLeft(2, '0')}:${mediaItem.createdAt.minute.toString().padLeft(2, '0')}',
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

  // Fungsi untuk membuka video di aplikasi galeri
  Future<void> _launchVideo(String filePath) async {
    final Uri _videoUri =
        Uri.parse(filePath); // Menggunakan path file lokal untuk video
    if (await canLaunchUrl(_videoUri)) {
      await launchUrl(_videoUri,
          mode: LaunchMode
              .externalApplication); // Membuka video dengan aplikasi galeri default
    } else {
      throw 'Could not launch $filePath'; // Menangani kasus jika tidak bisa membuka video
    }
  }

  String _monthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }
}
