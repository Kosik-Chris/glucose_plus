

class Chemicals{
  const Chemicals({this.title, this.reference});
  final String title;
  //Change list of initializing reference variables later
  //May need to change reference to U-short/ string etc.
  final int reference;
}

//Store all configuration settings in this constant settings
const List<Chemicals> ChemicalsValues = const <Chemicals>[

  const Chemicals(title: 'Glucose', reference: 1),
  const Chemicals(title: 'Chemical 2', reference: 2),
  const Chemicals(title: 'Chemical 3', reference: 3),
  const Chemicals(title: 'Chemical 4', reference: 4),
  const Chemicals(title: 'Chemicals 5', reference: 5),
  const Chemicals(title: 'Chemicals 6', reference: 6),
  const Chemicals(title: 'Chemicals 7', reference: 7)
];