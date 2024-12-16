import 'package:eproject/utils/app_constant.dart';
import 'package:flutter/material.dart';

class DrawerSideBar extends StatefulWidget {
  const DrawerSideBar({super.key});

  @override
  State<DrawerSideBar> createState() => _DrawerSideBarState();
}

class _DrawerSideBarState extends State<DrawerSideBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 180,
            width: 70,
            child: DrawerHeader(
              decoration: BoxDecoration(color: AppConstant().themeColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Container(
                      width: 50,
                      height: 50,
                      color: const Color.fromARGB(97, 5, 5, 5),
                      // child: _userImageURL.isNotEmpty
                      //     ? CachedNetworkImage(
                      //         imageUrl: _userImageURL,
                      //         placeholder: (context, url) =>
                      //             const CircularProgressIndicator(),
                      //         errorWidget: (context, url, error) =>
                      //             const Icon(Icons.error),
                      //       )
                      //     : (user?.providerData[0].providerId == 'google.com'
                      //         ? const Image(
                      //             image: AssetImage(
                      //               "assets/images/Defaultimage.png",
                      //             ),
                      //             fit: BoxFit.cover,
                      //           )
                      //         : null),
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Text(
                  //   _userName.isNotEmpty ? _userName : (user?.email ?? 'Guest'),
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: user?.providerData[0].providerId == 'google.com'
                  //         ? 15
                  //         : 15,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          ListTile(
            title: const Text(
              'Currency Converter',
              style: TextStyle(fontSize: 15.2),
            ),
            onTap: () => {
              Navigator.pushReplacementNamed(context, '/home')
            },
            leading: Icon(
              Icons.swap_horiz_sharp,
              size: 23,
              color: AppConstant().themeColor,
            ),
          ),
           Divider(
            color: AppConstant().secondaryColor,
            height: 5,
          ),
          ListTile(
            title: const Text(
              'Check History',
              style: TextStyle(fontSize: 15.2),
            ),
            onTap: () => {
              Navigator.pushReplacementNamed(context, '/history')
            },
            leading:  Icon(
              Icons.history,
              size: 23,
              color: AppConstant().themeColor,
            ),
          ),
           Divider(
            color: AppConstant().secondaryColor,
            height: 5,
          ),
          ListTile(
            title:  Text(
              'Rate Alerts',
              style: TextStyle(fontSize: 15.2),
            ),
            onTap: () => {
              Navigator.pushReplacementNamed(context, '/rate_alerts')
            },
            leading:  Icon(
              Icons.notification_add_outlined,
              size: 23,
              color: AppConstant().themeColor,
            ),
          ),
           Divider(
            color: AppConstant().secondaryColor,
            height: 5,
          ),
          // ListTile(
          //   title: const Text(
          //     'Notifications',
          //     style: TextStyle(fontSize: 15.2),
          //   ),
          //   onTap: () => {
          //     Navigator.pushReplacementNamed(context, '/notifications')
          //   },
          //   leading: Icon(
          //     Icons.notification_add_outlined,
          //     size: 23,
          //     color: AppConstant().themeColor,
          //   ),
          // ),
          //  Divider(
          //   color: AppConstant().secondaryColor,
          //   height: 5,
          // ),
          ListTile(
            title: const Text(
              'News',
              style: TextStyle(fontSize: 15.2),
            ),
             onTap: () => {
              Navigator.pushReplacementNamed(context, '/news')
            },
            leading:  Icon(
              Icons.article,
              size: 23,
              color: AppConstant().themeColor,
            ),
          ),
           Divider(
            color: AppConstant().secondaryColor,
            height: 5,
          ),
          ListTile(
            title: const Text(
              'Contact Support',
              style: TextStyle(fontSize: 15.2),
            ),
           onTap: () => {
              Navigator.pushReplacementNamed(context, '/contact')
            },
            leading: Icon(
              Icons.contact_page_outlined,
              size: 23,
              color: AppConstant().themeColor,
            ),
          ),
         Divider(
            color: AppConstant().secondaryColor,
            height: 5,
          ),
          ListTile(
            title: const Text(
              'Logout',
              style: TextStyle(fontSize: 15.2),
            ),
             onTap: () => {
              Navigator.pushReplacementNamed(context, '/logout')
            },
            leading: Icon(
              Icons.logout,
              size: 23,
              color: AppConstant().themeColor,
            ),
          ),
        ],
      ),
    );
    }
  }
