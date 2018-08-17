import 'package:firebase_database/firebase_database.dart';


class ChemicalsFire{

  String key;
  String title;
  String amount;
  String amountUnits;
  String autoCalibrate;
  String biasSign;
  String biasVoltage;
  String chemical;
  String concentration;
  String concentrationUnits;
  String currTimeSamplePeriod;
  String gain;
  String graphType;
  String loadResistor;
  String mode;
  String refSource;
  String reference;
  String voltCurrSamplePeriod;

  ChemicalsFire(this.title,this.amount,this.amountUnits,this.autoCalibrate,this.biasSign,
      this.biasVoltage,this.chemical,this.concentration,this.concentrationUnits,
      this.currTimeSamplePeriod,
      this.gain,this.graphType,this.loadResistor,this.mode,this.refSource,
      this.reference,this.voltCurrSamplePeriod);

  ChemicalsFire.fromSnapshot(DataSnapshot snapshot)
        :   key = snapshot.key,
            title = snapshot.value['title'],
            amount = snapshot.value['amount'],
            amountUnits = snapshot.value['amountUnits'],
            autoCalibrate = snapshot.value['autoCalibrate'],
            biasSign = snapshot.value['biasSign'],
            biasVoltage = snapshot.value['biasVoltage'],
            chemical = snapshot.value['chemical'],
            concentration = snapshot.value['concentration'],
            concentrationUnits = snapshot.value['concentrationUnits'],
            currTimeSamplePeriod = snapshot.value['currTimeSampleperiod'],
            gain = snapshot.value['gain'],
            graphType = snapshot.value['graphType'],
            loadResistor = snapshot.value['loadResistor'],
            mode = snapshot.value['mode'],
            refSource = snapshot.value['refSource'],
            reference = snapshot.value['reference'],
            voltCurrSamplePeriod = snapshot.value['voltCurrSamplePeriod'];

  toJson(){
    return{
      "title": title,
      "amount": amount,
      "amountUnits": amountUnits,
      "autoCalibrate": autoCalibrate,
      "biasSign": biasSign,
      "biasVoltage": biasVoltage,
      "chemical": chemical,
      "concentration": concentration,
      "concentrationUnits": concentrationUnits,
      "currTimeSamplePeriod": currTimeSamplePeriod,
      "gain": gain,
      "graphType": graphType,
      "loadResistor": loadResistor,
      "mode": mode,
      "refSource": refSource,
      "reference": reference,
      "voltCurrSamplePeriod": voltCurrSamplePeriod
    };
  }





}

