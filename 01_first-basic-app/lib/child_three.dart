import 'package:flutter/material.dart';

class ChildThree extends StatelessWidget {
  const ChildThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blueGrey[900],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Image.asset("assets/images/luffy.png", width: 50),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Himanshu Sharma",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 3,),

              Text(
                "Flutter Developer",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 3,),

              Text(
                "www.himanshuSharma.com",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 3,),

            ],
          ),
        ],
      ),
    );
  }
}
