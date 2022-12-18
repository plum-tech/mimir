import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import 'search/page/constant.dart';
import 'search/page/search_delegate.dart';
import 'using.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({Key? key}) : super(key: key);

  /// 随机获取一个名句
  Saying _getRandomSaying() {
    int size = Saying.sayings.length;
    int index = Random.secure().nextInt(size);
    return Saying.sayings[index];
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: i18n.ftype_library.text(),
      actions: [
        IconButton(
          onPressed: () {
            showSearch(context: context, delegate: SearchBarDelegate());
          },
          icon: const Icon(
            Icons.search,
          ),
        ),
        IconButton(
          onPressed: () async {
            showBasicFlash(context, i18n.libraryAccountManagementBtnTip.text());
          },
          icon: const Icon(
            Icons.person,
          ),
        ),
      ],
    );
  }

  Widget _buildSayingWidget({
    double? width,
  }) {
    final saying = _getRandomSaying();

    return Column(
      children: [
        // Hardcoded Chinese comma is used. Don't change this.
        ...saying.text.split('，').map((e) {
          return SizedBox(
            width: width,
            child: Center(
              child: Text(e),
            ),
          );
        }).toList(),
        const SizedBox(height: 20),
        SizedBox(
          width: width,
          child: Container(
            alignment: Alignment.bottomRight,
            child: Text(
              '——— ${saying.sayer}',
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var imageWidth = screenWidth * 0.6;
    var sayingWidth = screenWidth * 0.5;
    return Stack(
      children: [
        Center(
          child: SizedBox(
            height: 400,
            child: Column(
              children: [
                SizedBox(
                  width: imageWidth,
                  child: const Image(
                    image: AssetImage('assets/library/saying.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                _buildSayingWidget(
                  width: sayingWidth,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }
}
