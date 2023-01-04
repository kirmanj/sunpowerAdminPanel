import 'dart:math';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:cross_file/cross_file.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:explore/pdfread.dart';
import 'package:explore/web/responsive.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DestinationCarousel extends StatefulWidget {
  List _isHovering;
  List _isSelected;

  List<Map> brands;

  DestinationCarousel(this._isHovering, this._isSelected, this.brands);

  @override
  _DestinationCarouselState createState() => _DestinationCarouselState();
}

class _DestinationCarouselState extends State<DestinationCarousel> {
  final String imagePath = 'assets/images/';

  final CarouselController _controller = CarouselController();

  downloadFileWeb(String url, String fileName) async {
    final httpsReference = FirebaseStorage.instance.refFromURL(url);
    final imageUrl = await FirebaseStorage.instance
        .ref()
        .child("${httpsReference.fullPath}/Audi.pdf")
        .getDownloadURL();

    // print("Krmanj");
    // print(httpsReference);
    // try {
    //   const oneMegabyte = 1024 * 1024;
    //   final Uint8List? data = await httpsReference.getData(oneMegabyte);
    //   // Data for "images/island.jpg" is returned, use this as needed.
    //   XFile.fromData(data!,
    //           mimeType: "application/octet-stream", name: fileName + ".pdf")
    //       .saveTo("C:/"); // here Path is ignored
    // } on FirebaseException catch (e) {
    //   // Handle any errors.
    //   print(e.message);
    // }
    // for other platforms see this solution : https://firebase.google.com/docs/storage/flutter/download-files#download_to_a_local_file
  }

  previewPDFFile(url) {
    html.window.open(url, "_blank"); //opens pdf in new tab
  }

  int _current = 0;

  List<Map> brands = [];

  List<Widget> generateImageTiles(screenSize) {
    if (brands.length != widget.brands.length) {
      return brands
          .map(
            (element) => Container(
              child: Text("Loading..."),
            ),
          )
          .toList();
      ;
    } else {
      return brands
          .map(
            (element) => ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                element['image'],
                fit: BoxFit.cover,
              ),
            ),
          )
          .toList();
    }
  }

  loadImage() {
    widget.brands.forEach((element) async {
      var storage = FirebaseStorage.instance.ref().child(element['image']);
      String url = await storage.getDownloadURL();
      setState(() {
        brands.add(
            {"image": url, 'name': element['name'], 'pdf': element['pdf']});
      });
    });
  }

  @override
  void initState() {
    loadImage();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var imageSliders = generateImageTiles(screenSize);

    return brands.length != widget.brands.length
        ? Container(
            child: Center(child: Text('Loading....')),
          )
        : Container(
            width: ResponsiveWidget.isSmallScreen(context)
                ? null
                : screenSize.width * 0.7,
            height: ResponsiveWidget.isSmallScreen(context)
                ? null
                : screenSize.height * 0.7,
            child: Stack(
              children: [
                CarouselSlider(
                  items: imageSliders,
                  options: CarouselOptions(
                      scrollPhysics: ResponsiveWidget.isSmallScreen(context)
                          ? PageScrollPhysics()
                          : NeverScrollableScrollPhysics(),
                      enlargeCenterPage: true,
                      aspectRatio: 18 / 8,
                      autoPlay: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                          for (int i = 0; i < imageSliders.length; i++) {
                            if (i == index) {
                              widget._isSelected[i] = true;
                            } else {
                              widget._isSelected[i] = false;
                            }
                          }
                        });
                      }),
                  carouselController: _controller,
                ),
                AspectRatio(
                  aspectRatio: 18 / 8,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          brands[_current]['name'],
                          style: TextStyle(
                            letterSpacing: 8,
                            fontFamily: 'Electrolize',
                            fontSize: screenSize.width / 25,
                            color: Colors.white,
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          onHover: (value) {},
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReadPDF(
                                          brands[_current]['pdf'],
                                          brands[_current]['name'],
                                        )));
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: screenSize.height / 80,
                                bottom: screenSize.height / 90),
                            child: Icon(
                              Icons.picture_as_pdf,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ResponsiveWidget.isSmallScreen(context)
                    ? Container()
                    : AspectRatio(
                        aspectRatio: 17 / 8,
                        child: Center(
                          heightFactor: 1,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: screenSize.width / 8,
                                right: screenSize.width / 8,
                              ),
                              child: Card(
                                elevation: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Color.fromARGB(254, 246, 238, 50),
                                        Color.fromARGB(254, 211, 160, 38),
                                        Color.fromARGB(254, 246, 238, 50),
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: screenSize.height / 50,
                                      bottom: screenSize.height / 50,
                                    ),
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          for (int i = 0;
                                              i < widget.brands.length;
                                              i++)
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  onHover: (value) {
                                                    setState(() {
                                                      value
                                                          ? widget._isHovering[
                                                              i] = true
                                                          : widget._isHovering[
                                                              i] = false;
                                                    });
                                                  },
                                                  onTap: () {
                                                    _controller
                                                        .animateToPage(i);
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: screenSize.height /
                                                            80,
                                                        bottom:
                                                            screenSize.height /
                                                                90),
                                                    child: Text(
                                                      brands[i]['name'],
                                                      style: TextStyle(
                                                        color: widget
                                                                ._isHovering[i]
                                                            ? Theme.of(context)
                                                                .primaryTextTheme
                                                                .button!
                                                                .decorationColor
                                                            : Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  onHover: (value) {},
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    ReadPDF(
                                                                      brands[i][
                                                                          'pdf'],
                                                                      brands[i][
                                                                          'name'],
                                                                    )));
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: screenSize.height /
                                                            80,
                                                        bottom:
                                                            screenSize.height /
                                                                90),
                                                    child: Icon(
                                                      Icons.picture_as_pdf,
                                                      size: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  maintainSize: true,
                                                  maintainAnimation: true,
                                                  maintainState: true,
                                                  visible:
                                                      widget._isSelected[i],
                                                  child: AnimatedOpacity(
                                                    duration: Duration(
                                                        milliseconds: 400),
                                                    opacity:
                                                        widget._isSelected[i]
                                                            ? 1
                                                            : 0,
                                                    child: Container(
                                                      height: 5,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                      width:
                                                          screenSize.width / 15,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          );
  }
}
