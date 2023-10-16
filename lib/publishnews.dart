import 'dart:math';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:news_forum/Home.dart';
import 'package:permission_handler/permission_handler.dart';

class PublishNews extends StatefulWidget {
  const PublishNews({super.key});

  @override
  State<PublishNews> createState() => _PublishNewsState();
}

class _PublishNewsState extends State<PublishNews> {
  bool isadmin = false;
  GoogleSignInAccount? user;
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  String imageurl = "";
  String videourl = "";
  String month="", date="", time="";
  int tag = -1;
  List<String> options = [
    'Trending', 'World', 'India',
    'Business', 'Technology', 'Sports',
    'Food', 'Travel', 'Entertainment', 'Health',
    'Science', 'Other',
  ];
  List<String> cities = [
  "Baidyabati",
  "Baranagar",
  "Bardhaman",
  "Berhampore",
  "Bhadreswar",
  "Bhatpara",
  "Chandannagar",
  "Darjeeling",
  "Howrah",
  "Jalpaiguri",
  "Kamarhati",
  "Kharagpur",
  "Kolkata",
  "Krishnanagar",
  "Malda",
  "Midnapore",
  "Nabadwip",
  "Nadia",
  "Purulia",
  "Raiganj",
  "Serampore",
  "Siliguri",
  "Titagarh"
  ];
  bool showt = false;
  String cityname = "";
  bool showcityerror = false;
  bool headllineerror = false;
  bool contenterror = false;
  bool imageerror = false;
  bool tagerror = false;
  bool notadmin = false;
  bool videoupload = false;
  @override
  Widget build(BuildContext context) {
    User? userv = FirebaseAuth.instance.currentUser;
    if(userv==null){
      setState(() {
        isadmin=false;
      });
    }else{
      setState(() {
        isadmin = true;
      });
    }
    return Scaffold(body: SingleChildScrollView(child: Column(children: [
      SizedBox(height: 50,),
      Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text("News", style: TextStyle(fontSize: 40, color: Colors.black),), Text("Bite", style: TextStyle(fontSize: 40, color: Colors.teal),)],),
      SizedBox(height: 20,),
      isadmin ? Column(children: [
        Text("Enter the news details", style: TextStyle(fontSize: 25),),
        SizedBox(height: 25,),
        Container(
          width: 450,
          child: ChipsChoice.single(choiceStyle: C2ChipStyle(foregroundColor: Colors.black, backgroundAlpha: 20),value: tag, onChanged: (val) => setState(() {
            tag = val;
            tagerror = false;
          }),
              choiceItems: C2Choice.listFrom<int, String>(source: options, value: (i, v) => i, label: (i ,v)=> v),
          wrapped: true),
        ),
        tagerror ? Text("Please choose topic", style: TextStyle(color: Colors.red),) : SizedBox(height: 0,),

        SizedBox(height: 25,),
        Autocomplete(
            fieldViewBuilder: (context, search, focusNode, onEditingComplete){
              search.addListener(() {
                setState(() {
                  cityname = search.text;
                });
              });
              return Container(width: 450, child: Center(
                child: TextField(onChanged: (value){
                  if(value==""){
                    setState(() {
                      showcityerror = true;
                    });
                  }else{
                    setState(() {
                      showcityerror = false;
                    });
                  }
                }, onEditingComplete: onEditingComplete, focusNode: focusNode, cursorColor: Colors.purple,controller: search, decoration: InputDecoration(hintText: "Enter city name",enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: showcityerror ? Colors.red : Colors.grey, width: 2), borderRadius: BorderRadius.circular(5)),
                    focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black, width: 2), borderRadius: BorderRadius.circular(5))),
                  textAlign: TextAlign.center,style: const TextStyle(fontSize: 25),),));
            }, optionsBuilder: (TextEditingValue te){
          if(te.text==""){
            return const Iterable<String>.empty();
          }
          return cities.where((String item) {
            return item.toLowerCase().contains(te.text.toLowerCase());
          });
        }),
        SizedBox(height: 25,),
        Container(width: 450,child: TextField(onChanged: (value){
          if(value==""){
            setState(() {
              headllineerror = true;
            });
          }else{
            setState(() {
              headllineerror = false;
            });
          }
        }, maxLength: 100, minLines:1, maxLines: 3, cursorColor: Colors.purple,controller: title,
          decoration: InputDecoration(hintText: "Headline",enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: headllineerror ? Colors.red : Colors.grey, width: 2), borderRadius: BorderRadius.circular(5)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2), borderRadius: BorderRadius.circular(5))),
          textAlign: TextAlign.center,style: TextStyle(fontSize: 25),)),
        SizedBox(height: 25,),
        Container(width: 450,child: TextField(onChanged: (value){
          if(value==""){
            setState(() {
              contenterror = true;
            });
          }else{
            setState(() {
              contenterror =false;
            });
          }
        }, minLines:4, maxLines: 10, cursorColor: Colors.purple,controller: content, decoration: InputDecoration(hintText: "Content",enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: contenterror ? Colors.red : Colors.grey, width: 2), borderRadius: BorderRadius.circular(5)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 2), borderRadius: BorderRadius.circular(5))),
          textAlign: TextAlign.center,style: TextStyle(fontSize: 25),)),
        SizedBox(height: 25,),
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [GestureDetector(onTap: () async {
            final firebaseStorage0 = FirebaseStorage.instance;
            final imagePicker = ImagePicker();
            XFile? image;
            //Check Permissions
            if(!kIsWeb){
              await Permission.photos.request();
              var permissionStatuss = await Permission.photos.status;
              if (permissionStatuss.isGranted) {
                //Select Image
                image = await imagePicker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  Random random = Random();
                  String? hj = (random.nextInt(100000) + 10).toString();
                  var snapshot = firebaseStorage0
                      .ref("News Images/$hj")
                      .putData(await image.readAsBytes());

                  snapshot.snapshotEvents
                      .listen((TaskSnapshot taskSnapshot) async {
                    switch (taskSnapshot.state) {
                      case TaskState.running:
                        setState(() {
                          showt = true;
                        });
                        break;
                      case TaskState.paused:
                        break;
                      case TaskState.canceled:
                        break;
                      case TaskState.error:
                      // Handle unsuccessful uploads
                        break;
                      case TaskState.success:
                        String imageUrls = await (await snapshot).ref.getDownloadURL();
                        setState(() {
                          imageurl = imageUrls;
                          showt=false;
                          imageerror = false;
                        });

                        // Handle successful uploads on complete
                        // ...
                        break;
                    }
                  });
                } else {
                }
              } else {
              }
            }else{
              //Select Image
              Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();
              if (bytesFromPicker != null) {
                Random random = Random();
                String? hj = (random.nextInt(100000) + 10).toString();
                var snapshot = firebaseStorage0
                    .ref("News Images/$hj")
                    .putData(bytesFromPicker, SettableMetadata(contentType: 'image/jpg',)
                );

                snapshot.snapshotEvents
                    .listen((TaskSnapshot taskSnapshot) async {
                  switch (taskSnapshot.state) {
                    case TaskState.running:
                      setState(() {
                        showt = true;
                      });
                      break;
                    case TaskState.paused:
                      break;
                    case TaskState.canceled:
                      break;
                    case TaskState.error:
                    // Handle unsuccessful uploads
                      break;
                    case TaskState.success:
                      String imageUrls = await (await snapshot).ref.getDownloadURL();
                      setState(() {
                        imageurl = imageUrls;
                        showt=false;
                        imageerror = false;
                      });

                      // Handle successful uploads on complete
                      // ...
                      break;
                  }
                });
              } else {
              }
            }

          },child: Image.asset('images/image.png', height: 50,),),
            SizedBox(width: 10,),GestureDetector(onTap: () async {
              final firebaseStorage0 = FirebaseStorage.instance;
              final imagePicker = ImagePicker();
              XFile? image;
              //Check Permissions
              if(!kIsWeb){
                await Permission.photos.request();
                var permissionStatuss = await Permission.videos.status;
                if (permissionStatuss.isGranted) {
                  //Select Image
                  image = await imagePicker.pickVideo(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    Random random = Random();
                    String? hj = (random.nextInt(100000) + 10).toString();
                    var snapshot = firebaseStorage0
                        .ref("News Video/$hj")
                        .putData(await image.readAsBytes());

                    snapshot.snapshotEvents
                        .listen((TaskSnapshot taskSnapshot) async {
                      switch (taskSnapshot.state) {
                        case TaskState.running:
                          setState(() {
                            showt = true;
                          });
                          break;
                        case TaskState.paused:
                          break;
                        case TaskState.canceled:
                          break;
                        case TaskState.error:
                        // Handle unsuccessful uploads
                          break;
                        case TaskState.success:
                          String imageUrls = await (await snapshot).ref.getDownloadURL();
                          setState(() {
                            videourl = imageUrls;
                            showt=false;
                          });

                          // Handle successful uploads on complete
                          // ...
                          break;
                      }
                    });
                  } else {
                  }
                } else {
                }
              }else{
                //Select Image
                Uint8List? bytesFromPicker = await ImagePickerWeb.getVideoAsBytes();
                if (bytesFromPicker != null) {
                  Random random = Random();
                  String? hj = (random.nextInt(100000) + 10).toString();
                  var snapshot = firebaseStorage0
                      .ref("News Videos/$hj")
                      .putData(bytesFromPicker, SettableMetadata(contentType: 'video/mp4',)
                  );

                  snapshot.snapshotEvents
                      .listen((TaskSnapshot taskSnapshot) async {
                    switch (taskSnapshot.state) {
                      case TaskState.running:
                        setState(() {
                          showt = true;
                        });
                        break;
                      case TaskState.paused:
                        break;
                      case TaskState.canceled:
                        break;
                      case TaskState.error:
                      // Handle unsuccessful uploads
                        break;
                      case TaskState.success:
                        String imageUrls = await (await snapshot).ref.getDownloadURL();
                        setState(() {
                          videourl = imageUrls;
                          showt=false;
                          videoupload = true;
                        });

                        // Handle successful uploads on complete
                        // ...
                        break;
                    }
                  });
                } else {
                }
              }

            },child: Image.asset('images/video.png', height: 50,),),
        ]),
        imageerror ? Text("Please upload preview image", style: TextStyle(color: Colors.red),) : SizedBox(height: 0,),
        SizedBox(height: 25,),
        showt ? LoadingAnimationWidget.threeArchedCircle(
            color: Colors.black, size: 38) : SizedBox(height: 0,),
        (imageurl=="") ? SizedBox(height: 0,) : Image.network(imageurl, height: 200,),
        SizedBox(height: 25,),
        videoupload ? Text("Video uploaded successfully", style: TextStyle(color: Colors.green, fontSize: 18),) : SizedBox(height: 0,),
        SizedBox(height: 25,),
        Container(
          height: 45.0, //Provides height for the RaisedButton
          child: FractionallySizedBox(
            widthFactor: 0.1, ////Provides 70% width for the RaisedButton
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), side: const BorderSide(color: Colors.black87, width: 2)),
                onPressed: (){
                  if(tag!=-1 && title.text!="" && content.text!="" && imageurl!="" && cityname!=""){
                    int mon = DateTime.now().month;
                    switch (mon){
                      case 1:
                        month = "Jan";
                        break;
                      case 2:
                        month = "Feb";
                        break;
                      case 3:
                        month = "Mar";
                        break;
                      case 4:
                        month = "Apr";
                        break;
                      case 5:
                        month = "May";
                        break;
                      case 6:
                        month = "Jun";
                        break;
                      case 7:
                        month = "Jul";
                        break;
                      case 8:
                        month = "Aug";
                        break;
                      case 9:
                        month = "Sep";
                        break;
                      case 10:
                        month = "Oct";
                        break;
                      case 11:
                        month = "Nov";
                        break;
                      case 12:
                        month = "Dec";
                        break;
                    }
                    int cuurdate = DateTime.now().day;
                    date = cuurdate.toString();
                    int hour = DateTime.now().hour;
                    int hours = hour;
                    int minute = DateTime.now().minute;
                    String state = "";
                    if(hour<12){
                      state = "a.m.";
                    }else{state = "p.m.";}
                    if(hour>12){
                      hour = hour-12;
                    }
                    if(minute<10){
                      time = "$hour:0$minute $state";
                    }else{
                      time = "$hour:$minute $state";
                    }
                    int sec = DateTime.now().second;
                    String amonth = (mon<10) ? "0$mon" : "$mon";
                    String adate = (cuurdate<10) ? "0$cuurdate" : "$cuurdate";
                    String ahour = (hours<10) ? "0$hours" : "$hours";
                    String aminute = (minute<10) ? "0$minute" : "$minute";
                    String asecond = (sec<10) ? "0$sec" : "$sec";


                    String newid = amonth+adate+ahour+aminute+asecond;
                    FirebaseFirestore.instance.collection("News").doc(newid).set({
                      'title':title.text,
                      'content': content.text,
                      'image':imageurl,
                      'video':videourl,
                      'authorname':FirebaseAuth.instance.currentUser?.displayName,
                      'authorphoto': FirebaseAuth.instance.currentUser?.photoURL,
                      'date':"$month, $date",
                      'time': time,
                      'category': options[tag],
                      'city':cityname
                    }).then((value) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Home()),
                          ModalRoute.withName(""));
                    });
                  }else{
                    if(title.text==""){
                      setState(() {
                        headllineerror = true;
                      });
                    }
                    if(content.text==""){
                      setState(() {
                        contenterror = true;
                      });
                    }
                    if(cityname==""){
                      setState(() {
                        showcityerror = true;
                      });
                    }
                    if(imageurl==""){
                      setState(() {
                        imageerror = true;
                      });
                    }else{
                      setState(() {
                        imageerror = false;
                      });
                    }
                    if(tag==-1){
                      setState(() {
                        tagerror = true;
                      });
                    }
                  }
                },
                child: Text("Submit", style: TextStyle(color: Colors.black, fontSize: 25),)),
          ),
        ),
        SizedBox(height: 50,)






      ],) :
          Column(children: [
            Text("Please login to get access to publish news", style: TextStyle(fontSize: 25),),
            SizedBox(height: 20,),
            Center(
              child: SignInButton(
                Buttons.Google,
                text: "Continue with Google",
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                onPressed: () async {
                  user = await GoogleSignIn().signIn();
                  //user = kIsWeb ? await (GoogleSignIn().signInSilently()) : await (GoogleSignIn().signIn());
                  final GoogleSignInAuthentication? googleauth =
                  await user?.authentication;
                  final credential = GoogleAuthProvider.credential(
                      accessToken: googleauth?.accessToken,
                      idToken: googleauth?.idToken);

                  await FirebaseAuth.instance
                      .signInWithCredential(credential).catchError((e){
                    if(e.code == 'user-disabled'){
                      GoogleSignIn().signOut();
                      try {
                        GoogleSignIn().disconnect();
                      } catch (e) {}
                      FirebaseAuth.instance.signOut();
                      setState(() {
                        //showban = true;
                      });
                    }
                  });
                  String? mail = user?.email;
                  if (mail != null) {
                    FirebaseFirestore.instance.collection("Admins").doc(mail).get().then((value) {
                      if(value.exists){
                        setState(() {
                          isadmin = true;
                        });
                      }else{
                        GoogleSignIn().signOut();
                        try {
                          GoogleSignIn().disconnect();
                        } catch (e) {}
                        FirebaseAuth.instance.signOut();
                        setState(() {
                          isadmin = false;
                          notadmin = true;
                        });
                      }
                    });





                  }
                },
              ),
            ),
            SizedBox(height: 15,),
            notadmin ? Text("Only admin can publish news", style: TextStyle(color: Colors.red, fontSize: 20),) : SizedBox(height: 0,)
          ],)
    ],),),);
  }
}
