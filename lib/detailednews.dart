import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:news_forum/main.dart';
import 'package:pod_player/pod_player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'Home.dart';
class DetailedNews extends StatefulWidget {
  const DetailedNews({super.key});

  @override
  State<DetailedNews> createState() => _DetailedNewsState();
}
class _DetailedNewsState extends State<DetailedNews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SingleChildScrollView(child: Column(children: [
      SizedBox(height: 50,),
      Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text("News", style: TextStyle(fontSize: 40, color: Colors.black),), Text("Bite", style: TextStyle(fontSize: 40, color: Colors.teal),)],),
      SizedBox(height: 20,),
      Container(width: 600, child: Text(atitle, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),
      SizedBox(height: 20,),
      Container(
        height: 200,
        child: CachedNetworkImage(
          imageUrl: aimage,
          progressIndicatorBuilder: (_, url, download) {
            if (download.progress != null) {
              final percent = download.progress! * 100;
              return Center(
                child: CircularProgressIndicator(
                    color: const Color(0xff8a8989), value: percent),
              );
            }

            return const Text("");
          },
          errorWidget: (context, url, error) =>
          const Icon(Icons.image),
        ),
      ),
      SizedBox(height: 20,),
      Container(width: 600,child: Row(children: [Text("$acategory", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),),],),),
      Container(width: 600,child: Row(children: [Text("$acity, $adate,  $atime", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),),],),),
      SizedBox(height: 20,),
      (avideo == "") ? SizedBox(height: 0,) : TextButton(onPressed: (){
        launchUrl(Uri.parse(avideo),
            mode: LaunchMode.externalApplication);
      }, child: Text("Watch Video", style: TextStyle(fontSize: 20, color: Colors.teal),)),
      SizedBox(height: 20,),
      Container(width: 600, child: Text("                    $acontent", style: TextStyle(fontSize: 20),)),
      SizedBox(height: 30,),
      Container(width: 600, child: Row(children: [Spacer(), Column(children: [Text("Editor:", style: TextStyle(color: Colors.teal, fontSize: 25),),SizedBox(height: 5,),Container(width: 100, child: CachedNetworkImage(
        imageUrl: aauthorphoto,
        progressIndicatorBuilder: (_, url, download) {
          if (download.progress != null) {
            final percent = download.progress! * 100;
            return Center(
              child: CircularProgressIndicator(
                  color: const Color(0xff8a8989), value: percent),
            );
          }

          return const Text("");
        },
        imageBuilder: (context, imageProvider) => Container(
          width: 80.0,
          height: 80.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: imageProvider, fit: BoxFit.cover),
          ),
        ),
        errorWidget: (context, url, error) =>
        const Icon(Icons.person),
      ),),
        SizedBox(height: 10,),
        Text(aauthorname, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)],)],)),
      SizedBox(height: 100,)
    ],),),);
  }
}
