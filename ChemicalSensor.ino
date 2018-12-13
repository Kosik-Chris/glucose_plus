//Black red brown
// counter= longest, working= middle, ref= short end

#include <Wire.h>
#include <bluefruit.h>
#include "LMP91000.h"
#define sensor A3
#define MENB 7
#define vref 16

/*Enter the Parameters Here*/
//TIA..2P75K,3P5K,7K,14K,35K,120K,or 350K.. RLoad 10,33,50,100
//Reference Control source = INT,EXT..Z = 20PCT,50PCT,67PCT..Sign = POS,NEG..Bias = 0PCT,1PCT,2PCT,4PCT,6PCT,8PCT -> 24PCT
uint8_t TiaSet = TIA_350K;
uint8_t RSet = RLOAD_10;
float vrefVoltage = 0.0; // must be between 1.5 and vdd. Use 0.0 if using Ref_Source_INT.
uint8_t IntSet = INT_Z_50PCT;
uint8_t SignSet = BIAS_SIGN_POS;
uint8_t BiasSet = BIAS_14PCT;
uint8_t FetSet = FET_SHORT_DISABLED;
uint8_t ModeSet = MODE_AMPEROMETRIC;
int function = 3; // 0=current vs time, 1=current vs voltage, 2 = impedence vs time, 3 = current vs frequency, 4 = impedence vs freq,
//5 curr and imp vs time, 6 curr and imp vs freq, 7 is chemical detection for KCL
int accuracyVolt = 20; //how many mV/s
//int delayVoltamm = 330; //Delay inbetween samples for voltamm, only matters if Function is 1
int delayTime = 100;// Sample frequency if Function is set to 0
float vdd = 3.30; //Constant voltage going to vdd on the lmp91000.
bool autoCali = 1;
int totalPoints =  150; //how many points we want
/* No need to change any other parameters */


BLEUart bleuart;
bool startpro = 0;
const float resolution = 0.0008836156242;
const float analogCon = 78.4;
bool atBase = false;
int infreqStep = 0; // this is for the frequency sweep
int freqStep;
uint8_t gainArr [7] = {TIA_2P75K, TIA_3P5K, TIA_7K, TIA_14K, TIA_35K, TIA_120K, TIA_350K};
uint8_t gainIndex = 6;
int initalFreq = 1000000;
int infreqKept = 4; //length of freq set
int freq;
int freqKept;
uint8_t RefSet = REF_SOURCE_INT;
int raw;
int varyVoltage = 236;
int phase = 0;
float countPoints = 0;
int voltammStart = 0;
uint8_t bias;
float appliedVolt;
float result;
float current;
float voltage;
float biasVoltage = 0;
float biasPercent = 0;
int kclCount = 0;
float zero;
float gain;
int counter = 0;
int icounter = 0;
int sub = 0;
uint8_t TiaN;
uint8_t RefN;
uint8_t RefINT;
int newmess = 0;
LMP91000 lmp;
uint8_t buf[64];
uint8_t rec[64];
int len;
int i = 0;
int reci = 0;
int togglee = 1;
int counttt = 0;
int voltPoints = 0;


void setup(void) {
  Serial.begin(115200);
  Wire.begin();
  analogReadResolution(12);
  pinMode(MENB, OUTPUT);  //The enable to use I2C
  pinMode (sensor, INPUT); //The output from the LMP91000
  pinMode (vref, OUTPUT);
  configSettings();
  bluetoothStart();


}

void configSettings() {

  if (vrefVoltage != 0.00) {
    RefSet = REF_SOURCE_EXT;
    analogWrite(vref, vrefVoltage * analogCon);
    delay(25); // rise time delay
    vdd = vrefVoltage;
  }

  freq = initalFreq;
  freqKept = infreqKept * 1000000;
  freqStep = infreqStep;
  accuracyVolt = 3000 / accuracyVolt;


  digitalWrite(MENB, HIGH);
  delay(5);
  digitalWrite(MENB, LOW); //active low
  delay(1);
  if (autoCali == true)
    TiaSet = gainArr[gainIndex];
  lmp.change(TiaSet | RSet, RefSet | IntSet | SignSet | BiasSet, FetSet | ModeSet);//Write inital parameters

  setGainZero();
  delay(10); //wait a tad to start
   // displayInit(); //Checks/displays if lmp91000 was configured
}

void bluetoothStart() {
  Bluefruit.autoConnLed(true);

  Bluefruit.configPrphBandwidth(BANDWIDTH_MAX);

  Bluefruit.begin();
  Bluefruit.setTxPower(4);
  Bluefruit.setName("ElectroChemical");
  //Bluefruit.setConnectCallback(connect_callback);
  //Bluefruit.setDisconnectCallback(disconnect_callback);


  // Configure and Start BLE Uart Service
  bleuart.begin();

  // Set up and start advertising
  startAdv();
}



void startAdv(void)
{
  // Advertising packet
  Bluefruit.Advertising.addFlags(BLE_GAP_ADV_FLAGS_LE_ONLY_GENERAL_DISC_MODE);
  Bluefruit.Advertising.addTxPower();

  // Include bleuart 128-bit uuid
  Bluefruit.Advertising.addService(bleuart);
  Bluefruit.ScanResponse.addName();


  Bluefruit.Advertising.restartOnDisconnect(true);
  Bluefruit.Advertising.setInterval(32, 244);    // in unit of 0.625 ms
  Bluefruit.Advertising.setFastTimeout(30);      // number of seconds in fast mode
  Bluefruit.Advertising.start(0);                // 0 = Don't stop advertising after n seconds
}



void loop(void) {

  while ( bleuart.available() )
  {
    newmess = 1;
    rec [reci] = (uint8_t) bleuart.read();
    reci++;
  }
  if (newmess == 1) {
    decoder();

    //  for ( int k = 0; k < reci -1 ; k++){
    //    Serial.write(rec[k]);
    //  }
    //  Serial.println();
    //



    reci = 0;
  }

  if (startpro == 1) {

    switch (function) {
      case 0:
        delay(delayTime);
        currentVtime();
        displayRes();
        break;
      case 1:
        voltammetry();
        break;
      case 2:
        ImpTime();
        break;
      case 3:
        FrequencyCurrent();
        break;
      case 4:
        FrequencyImpedence();
        break;
      case 5:
        delay(delayTime);
        currentVtime();
        displayResBoth();
        break;
      case 6:
        delay(freq);
        freq = freq - freqStep;
        if (freq <= 0) {
          startpro = 0;
        }
        currentVtime();
        displayResBoth();
        break;
      case 7:
        if (kclCount < (6000 / 100)) {
          delay(delayTime);
          currentVtime();
          kclCount ++;
        }
        else {
          kclCount = 0;
          result = (result - 1.32) + 1.32;
          displayConc();
        }
        break;
      default:
        break;
    }

    if (autoCali == true && (raw > 3700 || raw < 25) && atBase == false) {
      if (gainIndex == 0) {
        Serial.println("Chemical Concentration is to high");
        atBase = true;
      }
      else {

        gainIndex--;
        configSettings();
        Serial.print("lowering gain to: ");
        Serial.print(gain * 1000);
        Serial.println("k");

      }
      if (function == 1) {
        voltammStart = 0;
        Serial.println("Restarting Voltammetry");
      }

    }
  }
  else {
    voltammStart = 0;
    freq = initalFreq;
    gainIndex = 6;
    freqKept = infreqKept * 1000000;
  freqStep = infreqStep;
    kclCount = 0;
  }

}





void FrequencyCurrent() {
  int freqCount;
  float freqTot = 0;
  for ( freqCount = 0; freqCount < (freqKept / freq); freqCount ++) {
    delayMicroseconds(freq);
    raw = analogRead(sensor);
    voltage = resolution * raw;
    freqTot = freqTot + ((voltage - (vdd * zero))) / gain;  
  }
result = freqTot / freqCount;
displayResF();
  freqStep = freqStep + 10;
  freq = 1000000/freqStep;
  if (freqStep >= 1000) {
  startpro = 0;
  }

}

void displayResF () {

  Serial.print(1000000/freq);
  Serial.print ("\t");
  Serial.println(result);

  setupTx();
  bleuart.write( buf, len + 1 );
  
}



void displayRes () {

  Serial.println(result);
  setupTx();
  bleuart.write( buf, len + 1 );
}

void displayConc() {
  Serial.println(result);
  setupTx();
  bleuart.write( buf, len + 1 );
}

void displayVoltammRes () {

  Serial.print(raw);
  Serial.print("\t");

  Serial.print(biasVoltage, 3);
  Serial.print("\t");
  Serial.println (result);

  setupTx();
  bleuart.write( buf, len + 1 );
}


void displayResBoth () {
  //  Serial.print("ADC reading: ");
  Serial.print(result);
  Serial.print("\t");
  if ( result < 0) {
    result = appliedVolt * -1000000 / result;
  }
  else {
    result = appliedVolt * 1000000 / result;
  }

  Serial.println(result);

  setupTx();
  bleuart.write( buf, len + 1 );
}

void setupTx() {

  String b = (String)result;
  len = b.length();
  char c[len];
  b.toCharArray(c, len + 1);

  for ( i = 0; i < len; i++) {
    buf[i] = c[i];
  }
  buf[i] = 10;
}

void currentVtime() {
  raw = analogRead(sensor);
  voltage = resolution * raw;
  result = (voltage - (vdd * zero)) / gain;


}




void FrequencyImpedence() {
  int freqCount;
 float freqTot = 0;
  for (freqCount = 0; freqCount < (freqKept / freq); freqCount ++) {
    delay(freq);
    raw = analogRead(sensor);
    voltage = resolution * raw;
    current = (voltage - (vdd * zero)) / gain;
    if ( current < 0) {
      freqTot = freqTot +(appliedVolt * -100000000 / current);
    }
    else{
      result = freqTot + (appliedVolt * 100000000 / current);
    }
  }
  result = freqTot / (100 * freqCount);
  displayResF();
  freqStep = freqStep + 10;
  freq = 1000000/freqStep;
  if (freqStep >= 1000) {
  startpro = 0;
}
}


void ImpTime() {
  delay(delayTime);
  raw = analogRead(sensor);
  voltage = resolution * raw;
  current = (voltage - (vdd * zero)) / gain;
  if ( current < 0) {
    result = appliedVolt * -1000000 / current;
  }
  else {
    result = appliedVolt * 1000000 / current;
  }

  displayRes();
}


void voltammetry() {

  if (voltammStart == 0) {
    lmp.sweep(128 | IntSet | 13);
    voltammStart = 1;
    phase = 1;
    sub = 1;
    voltPoints = 933 / totalPoints;
    varyVoltage = 236;
    biasPercent = -24;
    analogWrite(vref, varyVoltage);
    delay(500);
  }



  delay(accuracyVolt);
  if (voltPoints == 0) {

    raw = analogRead(sensor);
    voltage = resolution * raw;
    vdd = varyVoltage / 78.4;
    result = (voltage - (vdd * zero)) / gain; //current
    biasVoltage = (vdd * biasPercent) / 100;
    displayVoltammRes();
    voltPoints = 933 / totalPoints;
  }
  else {
    voltPoints--;
  }


  if (phase == 1) {


    if ( varyVoltage <= 118 && sub == 1) {
      sub = 2;
      biasPercent = -12;
      lmp.sweep(128 | IntSet | 7);
      varyVoltage = 236;
    }
    else if ( varyVoltage <= 118 && sub == 2) {
      sub = 4;
      biasPercent = -6;
      lmp.sweep(128 | IntSet | 4);
      varyVoltage = 236;
    }
    else if ( varyVoltage <= 118 && sub == 4) {
      sub = 6;
      biasPercent = -4;
      lmp.sweep(128 | IntSet | 3);
      varyVoltage = 177;
    }
    else if ( varyVoltage <= 118 && sub == 6) {
      sub = 12;
      biasPercent = -2;
      lmp.sweep(128 | IntSet | 2);
      varyVoltage = 236;
    }
    else if ( varyVoltage <= 118 && sub == 12) {
      sub = 24;
      biasPercent = -1;
      lmp.sweep(128 | IntSet | 1);
      varyVoltage = 236;
    }
    else if ( varyVoltage <= 118 && sub == 24) {
      biasPercent = 0;
      lmp.sweep(128 | IntSet | 0);
      varyVoltage = 142;
      phase = 2;
    }

    varyVoltage = varyVoltage - sub;
    analogWrite(vref, varyVoltage);

  }

  else if ( phase == 2) {
    biasPercent = 1;
    lmp.sweep(128 | IntSet | 16 | 1);
    phase = 3;
  }

  else if (phase == 3) {


    if ( varyVoltage >= 235 && sub == 1) {
      biasPercent = 24;
      lmp.sweep(128 | IntSet | 16 | 13);
      phase = 4;
    }
    else if ( varyVoltage >= 236 && sub == 2) {
      sub = 1;
      biasPercent = 24;
      lmp.sweep(128 | IntSet | 16 | 13);
      varyVoltage = 118;
    }
    else if ( varyVoltage >= 236 && sub == 4) {
      sub = 2;
      biasPercent = 12;
      lmp.sweep(128 | IntSet | 16 | 7);
      varyVoltage = 118;
    }
    else if ( varyVoltage >= 177 && sub == 6) {
      sub = 4;
      biasPercent = 6;
      lmp.sweep(128 | IntSet | 16 | 4);
      varyVoltage = 118;
    }
    else if ( varyVoltage >= 236 && sub == 12) {
      sub = 6;
      biasPercent = 4;
      lmp.sweep(128 | IntSet | 16 | 3);
      varyVoltage = 118;
    }
    else if ( varyVoltage >= 236 && sub == 24) {
      sub = 12;
      biasPercent = 2;
      lmp.sweep(128 | IntSet | 16 | 2);
      varyVoltage = 118;
    }

    varyVoltage = varyVoltage + sub;
    analogWrite(vref, varyVoltage);
  }


  else  if (phase == 4) {

    if ( varyVoltage <= 118 && sub == 1) {
      sub = 2;
      biasPercent = 12;
      lmp.sweep(128 | IntSet | 16 | 7);
      varyVoltage = 236;
    }
    else if ( varyVoltage <= 118 && sub == 2) {
      sub = 4;
      biasPercent = 6;
      lmp.sweep(128 | IntSet | 16 | 4);
      varyVoltage = 236;
    }
    else if ( varyVoltage <= 118 && sub == 4) {
      sub = 6;
      biasPercent = 4;
      lmp.sweep(128 | IntSet | 16 | 3);
      varyVoltage = 177;
    }
    else if ( varyVoltage <= 118 && sub == 6) {
      sub = 12;
      biasPercent = 2;
      lmp.sweep(128 | IntSet | 16 | 2);
      varyVoltage = 236;
    }
    else if ( varyVoltage <= 118 && sub == 12) {
      sub = 24;
      biasPercent = 1;
      lmp.sweep(128 | IntSet | 16 | 1);
      varyVoltage = 236;
    }
    else if ( varyVoltage <= 118 && sub == 24) {
      biasPercent = 0;
      lmp.sweep(128 | IntSet | 0);
      varyVoltage = 142;
      phase = 5;
    }

    varyVoltage = varyVoltage - sub;
    analogWrite(vref, varyVoltage);

  }
  else if ( phase == 5) {
    biasPercent = -1;
    lmp.sweep(128 | IntSet | 1);
    phase = 6;

  }

  else if (phase == 6) {


    if ( varyVoltage >= 236 && sub == 1) {
      biasPercent = 0;

      RefSet = REF_SOURCE_INT;
      vdd = 3.3;
      if (vrefVoltage != 0.00) {
        RefSet = REF_SOURCE_EXT;
        vdd = vrefVoltage;
      }
      lmp.sweep(RefSet | IntSet | SignSet | BiasSet);
      varyVoltage = (vrefVoltage * analogCon) - 1;
      startpro = 0;
    }
    else if ( varyVoltage >= 236 && sub == 2) {
      sub = 1;
      biasPercent = -24;
      lmp.sweep(128 | IntSet  | 13);
      varyVoltage = 118;
    }
    else if ( varyVoltage >= 236 && sub == 4) {
      sub = 2;
      biasPercent = -12;
      lmp.sweep(128 | IntSet  | 7);
      varyVoltage = 118;
    }
    else if ( varyVoltage >= 177 && sub == 6) {
      sub = 4;
      biasPercent = -6;
      lmp.sweep(128 | IntSet  | 4);
      varyVoltage = 118;
    }
    else if ( varyVoltage >= 236 && sub == 12) {
      sub = 6;
      biasPercent = -4;
      lmp.sweep(128 | IntSet  | 3);
      varyVoltage = 118;
    }
    else if ( varyVoltage >= 236 && sub == 24) {
      sub = 12;
      biasPercent = -2;
      lmp.sweep(128 | IntSet  | 2);
      varyVoltage = 118;
    }

    varyVoltage = varyVoltage + sub;
    analogWrite(vref, varyVoltage);
  }
}








//void voltammetry() {
//  if (voltammStart == 0) {
//    bias = (13 | RefINT);
//    lmp.sweep(bias);
//    voltammStart = 1;
//  }
//
//  delay(delayVoltamm);
//  raw = analogRead(sensor);
//  voltage = resolution * raw;
//  result = (voltage - (vdd * zero)) / gain;
//  displayRes();
//
//  if (counter == 0) {
//    if (icounter == 0) {
//      if ((bias | RefINT) > (2 | RefINT)) {
//        bias--;
//        lmp.sweep(bias);
//      }
//      else if ((bias | RefINT) == (0 | RefINT)) {
//        bias = 18 | RefINT;
//        icounter = 1;
//        //Serial.println();
//        lmp.sweep(bias);
//      }
//      else {
//        bias = 0 | RefINT;
//        lmp.sweep(bias);
//      }
//    }
//    else {
//      if ((bias | RefINT) == (29 | RefINT)) {
//        icounter = 0;
//        counter = 1;
//        bias--;
//        //Serial.println();
//        lmp.sweep(bias);
//      }
//      else {
//        bias ++;
//        lmp.sweep(bias);
//
//      }
//    }
//  }
//  else {
//    if (icounter == 0) {
//      if ((bias | RefINT) > (18 | RefINT)) {
//        bias--;
//        lmp.sweep(bias);
//      }
//      else if ((bias | RefINT) == (16 | RefINT)) {
//        bias = 2 | RefINT;
//        icounter = 1;
//        //Serial.println();
//        lmp.sweep(bias);
//      }
//      else {
//        bias = 16 | RefINT;
//        lmp.sweep(bias);
//      }
//    }
//    else {
//      if ((bias | RefINT) == (13 | RefINT)) {
//        icounter = 0;
//        counter = 0;
//        startpro = 0;
//        voltammStart = 0;
//        bias = 18 | RefINT;
//        //Serial.println("All done with Voltammetry");
//        lmp.sweep(bias);
//      }
//      else {
//        bias ++;
//        lmp.sweep(bias);
//
//      }
//    }
//  }
//
//}


void setGainZero() {
  TiaN = TiaSet;
  switch (TiaN) {
    case 4:
      gain = 0.00275;
      break;
    case 8:
      gain = 0.0035;
      break;
    case 12:
      gain = 0.007;
      break;
    case 16:
      gain = 0.014;
      break;
    case 20:
      gain = 0.035;
      break;
    case 24:
      gain = 0.12;
      break;
    case 28:
      gain = 0.35;
      break;
    default:
      gain = 0;
      break;
  }

  RefINT = IntSet | RefSet;
  switch (IntSet) {
    case 0:
      zero = 0.2;
      break;
    case 32:
      zero = 0.5;
      break;
    case 64:
      zero = 0.67;
      break;
    default:
      zero = 0;
      break;
  }

  if (RefSet == 0) {
    switch (BiasSet) {
      case 0:
        appliedVolt = vdd * 0;
        break;
      case 1:
        appliedVolt = vdd * 0.01;
        break;
      case 2:
        appliedVolt = vdd * 0.02;
        break;
      case 3:
        appliedVolt = vdd * 0.04;
        break;
      case 4:
        appliedVolt = vdd * 0.06;
        break;
      case 5:
        appliedVolt = vdd * 0.08;
        break;
      case 6:
        appliedVolt = vdd * 0.10;
        break;
      case 7:
        appliedVolt = vdd * 0.12;
        break;
      case 8:
        appliedVolt = vdd * 0.14;
        break;
      case 9:
        appliedVolt = vdd * 0.16;
        break;
      case 10:
        appliedVolt = vdd * 0.18;
        break;
      case 11:
        appliedVolt = vdd * 0.20;
        break;
      case 12:
        appliedVolt = vdd * 0.22;
        break;
      case 13:
        appliedVolt = vdd * 0.24;
        break;
    }


  }
  else {
    switch (BiasSet) {
      case 0:
        appliedVolt = vrefVoltage * 0;
        break;
      case 1:
        appliedVolt = vrefVoltage * 0.01;
        break;
      case 2:
        appliedVolt = vrefVoltage * 0.02;
        break;
      case 3:
        appliedVolt = vrefVoltage * 0.04;
        break;
      case 4:
        appliedVolt = vrefVoltage * 0.06;
        break;
      case 5:
        appliedVolt = vrefVoltage * 0.08;
        break;
      case 6:
        appliedVolt = vrefVoltage * 0.10;
        break;
      case 7:
        appliedVolt = vrefVoltage * 0.12;
        break;
      case 8:
        appliedVolt = vrefVoltage * 0.14;
        break;
      case 9:
        appliedVolt = vrefVoltage * 0.16;
        break;
      case 10:
        appliedVolt = vrefVoltage * 0.18;
        break;
      case 11:
        appliedVolt = vrefVoltage * 0.20;
        break;
      case 12:
        appliedVolt = vrefVoltage * 0.22;
        break;
      case 13:
        appliedVolt = vrefVoltage * 0.24;
        break;
    }

  }
}


void displayInit() {
  Serial.println("Initial setting for the LMP91000");
  Serial.print("TIA: ");
  Serial.println(lmp.read(TIACTRL), HEX);
  Serial.print("Reference: ");
  Serial.println(lmp.read(REFCTRL), HEX);
  Serial.print("Mode: ");
  Serial.println(lmp.read(MODECTRL), HEX);
}


void connect_callback(uint16_t conn_handle)
{
  char central_name[32] = { 0 };
  Bluefruit.Gap.getPeerName(conn_handle, central_name, sizeof(central_name));

  Serial.print("Connected to ");
  Serial.println(central_name);
}

void disconnect_callback(uint16_t conn_handle, uint8_t reason)
{
  (void) conn_handle;
  (void) reason;

  Serial.println();
  Serial.println("Disconnected");
}

void decoder() {
  /* debug purpose
    for ( int k = 0; k < reci -1 ; k++){
    Serial.write(rec[k]);
    }
    Serial.println();
  */
  newmess = 0;
  switch (rec[0]) {
    case 'a'://TIA
      TiaSet = (rec[1] & 0xf) * 100 + (rec[2] & 0xf) * 10 + (rec[3] & 0xf);
      Serial.println("Gain set");
      break;
    case 'b'://Rload
      RSet = (rec[1] & 0xf) * 100 + (rec[2] & 0xf) * 10 + (rec[3] & 0xf);
      Serial.println("Rload set");
      break;
    case 'c': //Ref source
      RefSet = (rec[1] & 0xf) * 100 + (rec[2] & 0xf) * 10 + (rec[3] & 0xf);
      Serial.println("Ref source set");
      break;
    case 'd': //internal zero
      IntSet = (rec[1] & 0xf) * 100 + (rec[2] & 0xf) * 10 + (rec[3] & 0xf);
      Serial.println("Internal zero set");
      break;
    case 'e': //bias sign
      SignSet = (rec[1] & 0xf) * 100 + (rec[2] & 0xf) * 10 + (rec[3] & 0xf);
      Serial.println("Bias sign set");
      break;
    case 'f': //bias percent
      BiasSet = (rec[1] & 0xf) * 100 + (rec[2] & 0xf) * 10 + (rec[3] & 0xf);
      Serial.println("Bias percent set");
      break;
    case 'g': //fet change
      FetSet = (rec[1] & 0xf) * 100 + (rec[2] & 0xf) * 10 + (rec[3] & 0xf);
      Serial.println("Fet set");
      break;
    case 'h': //mode control
      ModeSet = (rec[1] & 0xf) * 100 + (rec[2] & 0xf) * 10 + (rec[3] & 0xf);
      Serial.println("Mode set");
      break;
    case 'i': //function
      function = (rec[1] & 0xf) * 10 + (rec[2] & 0xf);
      Serial.println("Function Set");
      break;
    case 'j': // mV/s for voltammerty
      accuracyVolt  = (rec[1] & 0xf) * 1000 + (rec[2] & 0xf) * 100 + (rec[3] & 0xf) * 10 + (rec[4] & 0xf);
      Serial.println("Delay for Volt set");
      break;
    case 'k': //delay for current vs time
      delayTime = (rec[1] & 0xf) * 1000 + (rec[2] & 0xf) * 100 + (rec[3] & 0xf) * 10 + (rec[4] & 0xf);
      Serial.println("Delay for current sample set");
      break;
    case 'l': //vref voltage
      vrefVoltage = (rec[1] & 0xf)  + (rec[3] & 0xf) * 0.1 + (rec[4] & 0xf) * 0.01;
      Serial.println("Voltage ref set");
      break;
    case 'm': //vdd
      vdd = (rec[1] & 0xf)  + (rec[3] & 0xf) * 0.1 + (rec[4] & 0xf) * 0.01;
      Serial.println("VDD set");
      break;
    case 'n': //Congfig everything
      configSettings();
      Serial.println("Reconfigured");
      break;
    case 'o': //Start/Stop
      startpro =  (rec[1] & 0xf);
      //Serial.println("Start/Stop");
      break;
    case 'p': //auto calibrate
      autoCali = (rec[1] & 0xf);
      Serial.println("AutoCali Toggle");
      break;
    case 'q': //read lmp
      displayInit();
      break;
  }

}
