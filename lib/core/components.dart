 
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => widget),
  (Route<dynamic> route) => false,
);
void showToast({required String txt, required ToastState state}) {
  Fluttertoast.showToast(
    msg: txt,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

enum ToastState { success, error, worning }

late Color color;
Color chooseToastColor(ToastState state) {
  switch (state) {
    case ToastState.success:
      color = Colors.green;
      break;
    case ToastState.error:
      color = Colors.red;
      break;
    case ToastState.worning:
      color = Colors.amber;
      break;
  }
  return color;
}

ImageProvider getNetworkImageProvider(String? url) {
  if (url == null || url.isEmpty) {
    return const AssetImage('assets/images/logo.png');
  }
  return NetworkImage(url);
}

Widget buildNetworkImage(String? url, {double? width, double? height, BoxFit? fit}) {
  if (url == null || url.isEmpty) {
    return Image.asset(
      'assets/images/logo.png',
      width: width,
      height: height,
      fit: fit,
    );
  }
  return Image.network(
    url,
    width: width,
    height: height,
    fit: fit,
    errorBuilder: (context, error, stackTrace) => Image.asset(
      'assets/images/logo.png',
      width: width,
      height: height,
      fit: fit,
    ),
  );
}

Widget buildListProduct(
  model,
  context,
  //bool isOldPrice = true,
) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: SizedBox(
    height: 120.0,
    child: Row(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            buildNetworkImage(
               model.image,
              width: 120.0,
              height: 120.0,
            ),
            // if (model.discount != 0 && isOldPrice)
            Container(
              color: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: const Text(
                'DISCOUNT',
                style: TextStyle(fontSize: 8.0, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(width: 20.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14.0, height: 1.3),
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    model.price.toString(),
                    style: const TextStyle(fontSize: 12.0, color: Colors.black ),
                  ),
                  const SizedBox(width: 5.0),
                  // if (model.discount != 0 && isOldPrice)
                  /*  Text(
                          model.oldPrice.toString(),
                          style: const TextStyle(
                            fontSize: 10.0,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),*/
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: CircleAvatar(
                      radius: 15.0,
                      backgroundColor: Colors.grey,
                      child: const Icon(
                        Icons.favorite_border,
                        size: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);
