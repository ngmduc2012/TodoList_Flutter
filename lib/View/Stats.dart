import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Todos.dart';
import '../Controller/Provider.dart';

class FragStats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Consumer<MyModel>(
      builder: (context, mymodel, child) {
        mymodel.showList();
        return Center(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Completed Todos',
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 24.0),
                child: Text(
                  '${mymodel.countComplete}',
                  style: Theme
                      .of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Active Todos',
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 24.0),
                child: Text(
                  "${mymodel.countActive}",
                  style: Theme
                      .of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Colors.white),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
