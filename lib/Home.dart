import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:news_forum/detailednews.dart';
import 'package:news_forum/main.dart';
import 'package:news_forum/publishnews.dart';

import 'getter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
String atitle="", acontent="", aimage="", avideo="", adate="", atime="", aauthorname="", aauthorphoto="", acategory="", acity="";
class _HomeState extends State<Home> {
  TextEditingController email = TextEditingController();
  TextEditingController search = TextEditingController();
  List<Getter> list = [];
  List<Getter> mainlist = [];
  List lists = [];
  bool searchclear = false;
  bool cityclear = false;
  int tags = 0;
  String namecity = "";
  List<String> alltitles = [];
  List<String> optionss = [
    'All',
    'Trending', 'World', 'India',
    'Business', 'Technology', 'Sports',
    'Food', 'Travel', 'Entertainment', 'Health',
    'Science', 'Other',
  ];
  bool emailerror = false;
  bool havesubscribe = false;
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
  @override
  Widget build(BuildContext context) {

    FirebaseFirestore.instance.collection("News").get().then((QuerySnapshot querySnapshot) {
      for (var element in querySnapshot.docs) {
        String id = element.reference.id.toString();
        if(lists.contains(id)){
        }else{
          Getter getter = Getter(title: element['title'], content: element['content'], image: element['image'], video: element['video'], authorname: element['authorname'], authorphoto: element['authorphoto'], date: element['date'], time: element['time'], id: id, categry: element['category'], city: element['city']);
          setState(() {
            if(tags==0){
              if(namecity==""){
                list.insert(0, getter);
                mainlist.insert(0, getter);
                alltitles.insert(0, element['title']);
                lists.insert(0, id);
              }else if(namecity==element['city']){
                list.insert(0, getter);
                mainlist.insert(0, getter);
                alltitles.insert(0, element['title']);
                lists.insert(0, id);
              }
            }else if(element['category']==optionss[tags]){
              if(namecity==""){
                list.insert(0, getter);
                mainlist.insert(0, getter);
                alltitles.insert(0, element['title']);
                lists.insert(0, id);
              }else if(namecity==element['city']){
                list.insert(0, getter);
                mainlist.insert(0, getter);
                alltitles.insert(0, element['title']);
                lists.insert(0, id);
              }
            }
          });
        }
      }
    });

    return Scaffold(body: SingleChildScrollView(child: Column(children: [
      const SizedBox(height: 20,),
      Row(children: [const SizedBox(width: 50,),
        TextButton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
            return PublishNews();
          }));
        }, child: Text("Publish News", style: TextStyle(fontSize: 20, color: Colors.teal),)),
        const Spacer(),
        Column(
          children: [Container(height: 35,width: 280, child: Center(
            child: TextField(
              onChanged: (value){
                setState(() {
                  havesubscribe = false;
                });
                if(value==""){
                  setState(() {
                    emailerror = true;
                  });
                }else{
                  setState(() {
                    emailerror = false;
                  });
                }
              },
              cursorColor: Colors.purple,controller: email, decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(vertical: 0.0),hintText: "Enter E-mail address",enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: emailerror ? Colors.red : Colors.grey, width: 2), borderRadius: BorderRadius.circular(5)),
              focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black, width: 2), borderRadius: BorderRadius.circular(5))),
            textAlign: TextAlign.center,style: const TextStyle(fontSize: 18),),)),
            emailerror ? Text("Enter a valid email ID", style: TextStyle(color: Colors.red),) : SizedBox(height: 0,),
            havesubscribe ? const Text("Subscribed successfully", style: TextStyle(color: Colors.green),) : SizedBox(height: 0,),
          ]),
      SizedBox(width: 10,),
      Container(height: 35, child: ElevatedButton(onPressed: (){
        setState(() {
          havesubscribe = false;
        });
        if(email.text!=""){
          bool isemail = EmailValidator.validate(email.text);
          if(isemail){
            FirebaseFirestore.instance.collection("Subscribers").doc(email.text).set({'subscribe':'yes'}).then((value) {
              setState(() {
                email.clear();
                havesubscribe = true;
              });
            });
          }else{
            setState(() {
              emailerror = true;
              email.clear();
            });
          }

        }else{
          setState(() {
            emailerror = true;
          });
        }
      }, child: Text("SUBSCRIBE", style: TextStyle(fontSize: 15),), style: ElevatedButton.styleFrom(backgroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),)),
      SizedBox(width: 10,),
        SizedBox(width: 50,)]),
      SizedBox(height: 20,),
      Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text("News", style: TextStyle(fontSize: 40, color: Colors.black),), Text("Bite", style: TextStyle(fontSize: 40, color: Colors.teal),)],),
      SizedBox(height: 20,),
      Autocomplete(
          fieldViewBuilder: (context, search, focusNode, onEditingComplete){
        void cleartext() {
          search.clear();
        }
        search.addListener(() {
          list.clear();
          setState(() {
            if(search.text==""){
              searchclear= false;
              for(int ii=mainlist.length-1; ii>=0; ii--){
                list.insert(0, mainlist[ii]);
              }
            }else{
              searchclear= true;
              for(int ii=mainlist.length-1; ii>=0; ii--){
                if(mainlist[ii].title.toLowerCase().contains(search.text.toLowerCase())){
                  list.insert(0, mainlist[ii]);
                }
              }
            }
          });
        });
        return Container(width: 450, child: Center(
          child: TextField(onEditingComplete: onEditingComplete, focusNode: focusNode, cursorColor: Colors.purple,controller: search, decoration: InputDecoration(suffixIconColor: Colors.red,suffixIcon: Visibility(visible: searchclear,child: IconButton(onPressed: cleartext, icon: Icon(Icons.clear))), prefixIconColor: Colors.black,prefixIcon: Icon(Icons.search),contentPadding: const EdgeInsets.symmetric(vertical: 0.0),hintText: "Search...",enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2), borderRadius: BorderRadius.circular(5)),
              focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black, width: 2), borderRadius: BorderRadius.circular(5))),
            textAlign: TextAlign.center,style: const TextStyle(fontSize: 22),),));
      }, optionsBuilder: (TextEditingValue te){
        if(te.text==""){
          return const Iterable<String>.empty();
        }
        return alltitles.where((String item) {
          return item.toLowerCase().contains(te.text.toLowerCase());
        });
      }),
      SizedBox(height: 15,),
      SizedBox(height: 25,),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Container(
          width: 450,
          child: ChipsChoice.single(choiceStyle: C2ChipStyle(foregroundColor: Colors.black, backgroundAlpha: 20), value: tags, onChanged: (val) => setState(() {
            tags = val;
            list.clear();
            lists.clear();
            mainlist.clear();
            alltitles.clear();
          }),
              choiceItems: C2Choice.listFrom<int, String>(source: optionss, value: (i, v) => i, label: (i ,v)=> v),
              wrapped: true),
        ),
          SizedBox(width: 50,),
          Autocomplete(
              onSelected: (value){
                setState(() {
                  namecity = value;
                  list.clear();
                  lists.clear();
                  mainlist.clear();
                  alltitles.clear();
                });
              },
              fieldViewBuilder: (context, search, focusNode, onEditingComplete){
                void cleartext() {
                  search.clear();
                }
                search.addListener(() {
                  if(search.text==""){
                    setState(() {
                      namecity = "";
                      list.clear();
                      lists.clear();
                      mainlist.clear();
                      alltitles.clear();

                      cityclear = false;
                    });

                  }else{
                    setState(() {
                      cityclear = true;
                    });
                  }
                });
                return Container(width: 250, child: Center(
                  child: TextField(onEditingComplete: onEditingComplete, focusNode: focusNode, cursorColor: Colors.purple,controller: search, decoration: InputDecoration(prefixIconColor: Colors.black,prefixIcon: Icon(Icons.search),suffixIconColor: Colors.red,suffixIcon: Visibility(visible: cityclear,child: IconButton(onPressed: cleartext, icon: Icon(Icons.clear))), contentPadding: const EdgeInsets.symmetric(vertical: 0.0),hintText: "City...",enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey, width: 2), borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black, width: 2), borderRadius: BorderRadius.circular(5))),
                    textAlign: TextAlign.center,style: const TextStyle(fontSize: 22),),));
              }, optionsBuilder: (TextEditingValue te){
            if(te.text==""){
              return const Iterable<String>.empty();
            }
            return cities.where((String item) {
              return item.toLowerCase().contains(te.text.toLowerCase());
            });
          }),
      ]),
      (mainlist.isEmpty) ? Column(children: [SizedBox(height: 100,),Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [Text("No", style: TextStyle(color: Colors.red, fontSize: 35),),Text(" News", style: TextStyle(color: Colors.black, fontSize: 35))])]) : Container(child: (list.isEmpty) ? Column(children: [SizedBox(height: 100,),Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [Text("No", style: TextStyle(color: Colors.red, fontSize: 35),),Text(" News", style: TextStyle(color: Colors.black, fontSize: 25))])]) : Container(
        width: 800,
        height: (350*list.length).toDouble(),
        child: ListView.builder(itemCount: list.length, itemBuilder: (BuildContext context, int i){
          return GestureDetector(onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
              newsid = list[i].id;
              atitle = list[i].title;
              acontent = list[i].content;
              aimage = list[i].image;
              avideo = list[i].video;
              adate = list[i].date;
              atime = list[i].time;
              aauthorname = list[i].authorname;
              aauthorphoto = list[i].authorphoto;
              acategory = list[i].categry;
              acity = list[i].city;
              return DetailedNews();
            }));
          }, child: Card(child: Column(children: [

            SizedBox(height: 10,),
              Container(width: 700, child: Text(list[i].title, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),textAlign: TextAlign.center,)),
              SizedBox(height: 15,),
            Container(height: 150, child: Image.network(list[i].image)),
            SizedBox(height: 5,),Row(children: [SizedBox(width: 20,),Text("${list[i].categry}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),)]),
            Row(children: [SizedBox(width: 20,),Text("${list[i].city}, ${list[i].date},  ${list[i].time}", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),)]),
            SizedBox(height: 5,),
            Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text((list[i].content.length>150) ? list[i].content.substring(0,150) : list[i].content, style: TextStyle(fontSize: 16),))
            ,SizedBox(height: 10,),
          ]),
          ));
        }),
      ))
    ],),),);
  }
}


