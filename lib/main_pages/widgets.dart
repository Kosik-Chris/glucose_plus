import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ServiceTile extends StatelessWidget {
  final BluetoothService service;
  final List<CharacteristicTile> characteristicTiles;

  const ServiceTile({Key key, this.service, this.characteristicTiles})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (characteristicTiles.length > 0) {
      return new ExpansionTile(
        title: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Service'),
            new Text(
                '0x${service.uuid.toString().toUpperCase().substring(4, 8)}',
                style: Theme
                    .of(context)
                    .textTheme
                    .body1
                    .copyWith(color: Theme.of(context).textTheme.caption.color))
          ],
        ),
        children: characteristicTiles,
      );
    } else {
      return new ListTile(
        title: const Text('Service'),
        subtitle: new Text(
            '0x${service.uuid.toString().toUpperCase().substring(4, 8)}'),
      );
    }
  }
}

class CharacteristicTile extends StatelessWidget {
  final BluetoothCharacteristic characteristic;
  final List<DescriptorTile> descriptorTiles;
  final VoidCallback onReadPressed;
  final VoidCallback onWritePressed;
  final VoidCallback onNotificationPressed;

  const CharacteristicTile(
      {Key key,
        this.characteristic,
        this.descriptorTiles,
        this.onReadPressed,
        this.onWritePressed,
        this.onNotificationPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var actions = new Row(
      children: <Widget>[
        new IconButton(
          icon: new Icon(
            Icons.file_download,
            color: Theme.of(context).iconTheme.color.withOpacity(0.5),
          ),
          onPressed: onReadPressed,
        ),
        new IconButton(
          icon: new Icon(Icons.file_upload,
              color: Theme.of(context).iconTheme.color.withOpacity(0.5)),
          onPressed: onWritePressed,
        ),
        new IconButton(
          icon: new Icon(
              characteristic.isNotifying ? Icons.sync_disabled : Icons.sync,
              color: Theme.of(context).iconTheme.color.withOpacity(0.5)),
          onPressed: onNotificationPressed,
        )
      ],
    );

    var title = new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Characteristic'),
        new Text(
            '0x${characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
            style: Theme
                .of(context)
                .textTheme
                .body1
                .copyWith(color: Theme.of(context).textTheme.caption.color))
      ],
    );

    if (descriptorTiles.length > 0) {
      return new ExpansionTile(
        title: new ListTile(
          title: title,
          subtitle: new Text(characteristic.value.toString()),
        ),
        trailing: actions,
        children: descriptorTiles,
      );
    } else {
      return new ListTile(
        title: title,
        subtitle: new Text(characteristic.value.toString()),
        trailing: actions,
      );
    }
  }
}

class DescriptorTile extends StatelessWidget {
  final BluetoothDescriptor descriptor;
  final VoidCallback onReadPressed;
  final VoidCallback onWritePressed;

  const DescriptorTile(
      {Key key, this.descriptor, this.onReadPressed, this.onWritePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var title = new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Descriptor'),
        new Text(
            '0x${descriptor.uuid.toString().toUpperCase().substring(4, 8)}',
            style: Theme
                .of(context)
                .textTheme
                .body1
                .copyWith(color: Theme.of(context).textTheme.caption.color))
      ],
    );
    return new ListTile(
      title: new ListTile(
        title: title,
        subtitle: new Text(descriptor.value.toString()),
        trailing: new Row(
          children: <Widget>[
            new IconButton(
              icon: new Icon(
                Icons.file_download,
                color: Theme.of(context).iconTheme.color.withOpacity(0.5),
              ),
              onPressed: onReadPressed,
            ),
            new IconButton(
              icon: new Icon(
                Icons.file_upload,
                color: Theme.of(context).iconTheme.color.withOpacity(0.5),
              ),
              onPressed: onWritePressed,
            )
          ],
        ),
      ),
    );
  }
}