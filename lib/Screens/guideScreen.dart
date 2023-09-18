import 'package:flutter/material.dart';
import 'package:newui/Screens/chiewe.dart';
import 'package:video_player/video_player.dart';

class guideScreen extends StatefulWidget {
  const guideScreen({super.key});

  @override
  State<guideScreen> createState() => _guideScreenState();
}

Color blue = const Color(0xff3a57e8);

// ignore: camel_case_types
class _guideScreenState extends State<guideScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        title: const Text('GUIDE'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: Text(
                          '1. Hajj Takbeer',
                          style: TextStyle(
                              color: blue, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        child: SizedBox(
                          height: 250,
                          child: ChewieListItem(
                            videoPlayerController: VideoPlayerController.asset(
                              'assets/images/hajjtakber.mp4',
                            ),
                            looping: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          'The Hajj Takbeer holds profound significance in the hearts of Muslims worldwide. This melodious and resonant chant, recited in unison by pilgrims during the annual Hajj pilgrimage, symbolizes the unity and devotion of the Islamic community. It serves as a reminder of the diversity and oneness of the Muslim Ummah, transcending geographical, linguistic, and cultural boundaries. '
                          'The Hajj Takbeer echoes the triumphant praise of Allah, celebrating the fulfillment of a fundamental pillar of Islam and the spiritual journey of a lifetime. It encapsulates the essence of submission, faith, and the ultimate quest for closeness to God, making it a cherished and '
                          'spiritually uplifting tradition for Muslims around the world.',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 30, thickness: 1),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: Text(
                          '2. Hajj Perform Guide',
                          style: TextStyle(
                              color: blue, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 250,
                        child: ChewieListItem(
                          videoPlayerController: VideoPlayerController.asset(
                            'assets/images/hajjvideo.mp4',
                          ),
                          looping: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          'The process of Hajj follows a meticulously structured schedule, with specific dates and rituals that millions of Muslims undertake each year. It begins with the pilgrim\'s intention, known as niyyah, to embark on this sacred expedition. Pilgrims then wear the simple, white attire of ihram, signifying a state of purity and equality before God. The pilgrimage typically starts in Mecca, where participants perform Tawaf, circumambulating the Kaaba, Islam\'s holiest shrine, seven times. This is followed by Sa\'i, the act of walking seven times between the hills of Safa and Marwah, commemorating Hagar\'s search for water.'
                          'The next essential step is the journey to the plain of Arafat, which takes place on the 9th day of the Islamic month of Dhu al-Hijjah. Here, pilgrims spend a day in prayer and supplication, seeking forgiveness and renewing their commitment to God. After sunset, the pilgrims head to Muzdalifah, where they collect pebbles for the symbolic Stoning of the Devil ritual.'
                          'The climax of Hajj is the symbolic sacrifice of an animal, often a lamb or a goat, which takes place on the 10th day of Dhu al-Hijjah. This act represents the willingness to sacrifice for God. Pilgrims then shave their heads or trim their hair, signifying humility and purification. Following this, they return to Mecca to perform Tawaf al-Ifadah, another circumambulation of the Kaaba.'
                          'The process concludes with a return to Mina for the remaining days of the Hajj, during which pilgrims perform the Stoning of the Devil by throwing pebbles at three pillars. This ritual symbolizes the rejection of evil temptations and occurs on the 11th, 12th, and 13th days of Dhu al-Hijjah.'
                          'Throughout the entire journey, Hajj serves as a profound spiritual experience, fostering unity, humility, and devotion among Muslims. It is a testament to the power of faith and the importance of communal worship in Islam.',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 30, thickness: 1),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: Text(
                          '3. Ummrah Perform Guide',
                          style: TextStyle(
                              color: blue, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 250,
                        child: ChewieListItem(
                          videoPlayerController: VideoPlayerController.asset(
                            'assets/images/ummrahguide.mp4',
                          ),
                          looping: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        // padding: EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          'Performing Umrah, a significant pilgrimage for Muslims, involves several distinct steps, each imbued with spiritual significance.'
                          '1. **Ihram**: The journey begins with the pilgrim assuming a state of ihram, which involves wearing special white clothing for men and modest attire for women. Ihram symbolizes purity and detachment from worldly comforts, emphasizing spiritual focus.'
                          '2. **Tawaf**: Upon arrival in Mecca, pilgrims circumambulate the Kaaba, known as Tawaf. This act signifies the unity of Muslims around the world in their devotion to God. Pilgrims walk seven times counterclockwise around the Kaaba, reciting prayers and supplications.'
                          '3. **Sa\'i**: After Tawaf, pilgrims proceed to perform Sa\'i, which involves walking seven times between the hills of Safa and Marwah. This act commemorates Hagar\'s search for water and highlights perseverance and trust in God.'
                          '4. **Tahallul**: Pilgrims then shave their heads (or trim their hair) as a sign of humility, purification, and a fresh start in their spiritual journey.'
                          '5. **Tawaf al-Ifadah**: After a brief rest, pilgrims return to the Kaaba to perform another Tawaf, known as Tawaf al-Ifadah. This act symbolizes the completion of Umrah and allows pilgrims to seek forgiveness and blessings.'
                          '6. **Prayers at Maqam Ibrahim**: Pilgrims offer two rak\'ahs of prayer behind the Maqam Ibrahim, a stone bearing the footprint of the Prophet Ibrahim (Abraham), highlighting the connection between faith and lineage.'
                          '7. **Drink from Zamzam**: Pilgrims may also drink from the sacred Zamzam well, seeking spiritual sustenance and blessings.'
                          'While Umrah is distinct from the Hajj pilgrimage, its steps reflect deep-rooted religious symbolism and serve as a powerful spiritual journey for Muslims. It provides an opportunity for reflection, purification, and closeness to God, allowing individuals to renew their faith and seek His mercy and forgiveness.',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 30, thickness: 1),
            ],
          ),
        ),
      ),
    );
  }
}
