import 'package:edverhub_video_editor/variables.dart';

const List<String> FFMPEG_FILTER_NAMES = [
  "Original",
  'Sepia',
  'Greyscale',
  'New Times',
  'Newtimes 2',
  'Pink Autum',
  'Alien',
  'Old Times',
  'More Red',
  'Early Bird',
  'Pastel',
  'Pastel Yellow',
  'Cool Blue',
  'Mars',
  'RGB Lag',
  'Vintage',
  'Vintage 2',
  'Milk',
  'Sweet',
  //
  //
  '1977',
  'Afterglow',
  'Alice',
  'Ambers',
  'Blue yellow',
  'Brannan',
  'Gotham',
  'Grading',
  'Hefe',
  'Light parades',
  'Lord Kelvin',
  'Nashville',
  'Ocean',
  'Peacock',
  'X-PRO II',
];

List<String> FFMPEG_FILTERS = [
  "ORIGINAL",
  SEPIA,
  GREYSCALE,
  NEWTIMES,
  NEWTIMES_2,
  PINK_AUTUM,
  ALIEN,
  OLDTIMES,
  MORE_RED,
  EARLYBIRD,
  PASTEL,
  PASTEL_YELLOW,
  COOL_BLUE,
  MARS,
  RGB_LAG,
  VINTAGE,
  VINTAGE_2,
  MILK,
  SWEET,
  //
  //
  INSTA_1977,
  AFTERGLOW,
  ALICE,
  AMBERS,
  BLUE_YELLOW,
  BRANNAN,
  GOTHAM,
  GRADING,
  HEFE,
  LIGHT_PARADES,
  LORD_KELVIN,
  NASHVILLE,
  OCEAN,
  PEACOCK,
  XPROII,
];

// const String SEPIA = '-filter_complex "[0:v]colorchannelmixer=0.393:0.769:0.189:0.0:0.349:0.686:0.168:0.0:0.272:0.534:0.131:1.0[v]" -map \'[v]\' -an';
const String SEPIA = '-vf curves=master=\'0/0 0.89/0.84 1/1\':g=\'0/0 0.51/0.48 1/1\':b=\'0/0 0.69/0.32 1/1\'';
const String GREYSCALE = '-filter_complex \'[0:v]colorchannelmixer=0.3:0.4:0.3:0.0:0.3:0.4:0.3:0.0:0.3:0.4:0.3[v]\'';
const String NEWTIMES = '-filter_complex \'[0:v]colorchannelmixer=1.0:0.0:0.0:0.0:0.0:-0.4:1.3:-0.4:0.2:-0.1:1.0[v]\'';
const String NEWTIMES_2 = '-filter_complex \'[0:v]colorchannelmixer=0.82:0.0:0.0:0.0:0.0:0.0:0.73:0.0:0.0:0.0:1.0[v]\'';
const String PINK_AUTUM = '-filter_complex \'[0:v]colorchannelmixer=0.5:0.0:0.5:0.1:-0.2:1.2:-0.3:0.2:-0.2:0.4:0.6[v]\'';
const String ALIEN = '-filter_complex \'[0:v]colorchannelmixer=0.0:1.0:0.0:0.0:1.0:0.0:0.0:0.0:0.0:0.0:1.0:0.0:0.0:0.0:0.0:1.0[v]\'';
const String OLDTIMES = '-filter_complex \'[0:v]colorchannelmixer=0.5:0.0:0.5:0.0:0.0:1.0:0.0:0.0:0.0:0.0:0.5:0.0:0.0:0.0:0.0:1.0[v]\'';
const String MORE_RED = '-filter_complex \'[0:v]colorchannelmixer=0.9:0.0:0.0:0.0:0.0:1.1:0.0:0.0:0.0:0.0:1.0:0.0:0.0:0.0:0.0:1.0[v]\'';
const String EARLYBIRD = '-filter_complex \'[0:v]colorchannelmixer=0.82:0.0:0.0:0.0:0.0:0.73:0.0:0.0:0.0:0.0:0.56[v]\'';
const String PASTEL = '-filter_complex \'[0:v]colorchannelmixer=1.5:-0.25:-0.25:0.0:0.0:-0.25:1.5:-0.25:0.0:0.0:1.0[v]\'';
const String PASTEL_YELLOW = '-filter_complex \'[0:v]colorchannelmixer=1.5:-0.25:-0.25:0.0:-0.25:1.5:-0.25:0.0:-0.25:-0.25:1.0[v]\'';
const String COOL_BLUE = '-filter_complex \'[0:v]colorchannelmixer=2.0:-1.0:-1.0:0.0:0.0:-1.0:2.0:-1.0:0.0:0.0:1.0[v]\'';
const String MARS = '-filter_complex \'[0:v]colorchannelmixer=2.0:-1.0:-1.0:0.0:-1.0:2.0:-1.0:0.0:-1.0:-1.0:1.0[v]\'';

const String RGB_LAG = '-vf rgbashift=rh=-6:gh=6';
const String VINTAGE = '-vf curves=vintage';
const String VINTAGE_2 = '-filter_complex \'[0:v]colorchannelmixer=0.9:0.5:0.1:0:0.3:0.8:0.1:0:0.2:0.3:0.5:0[v]\'';
const String MILK = '-filter_complex \'[0:v]colorchannelmixer=0:1:0:0:0:1:0:0:0:0.6:1:0[v]\'';
const String SWEET = '-filter_complex \'[0:v]colorchannelmixer=1:0:0.2:0:0:1:0:0:0:0:1:0[v]\'';

String INSTA_1977 = "-vf curves=psfile=$appDirectory/acv/1977.acv";
String AFTERGLOW = "-vf curves=psfile=$appDirectory/acv/afterglow.acv";
String ALICE = "-vf curves=psfile=$appDirectory/acv/alice.acv";
String AMBERS = "-vf curves=psfile=$appDirectory/acv/ambers.acv";
String BLUE_YELLOW = "-vf curves=psfile=$appDirectory/acv/blue-yellow.acv";
String BRANNAN = "-vf curves=psfile=$appDirectory/acv/brannan.acv";
String GOTHAM = "-vf curves=psfile=$appDirectory/acv/gotham.acv";
String GRADING = "-vf curves=psfile=$appDirectory/acv/grading.acv";
String HEFE = "-vf curves=psfile=$appDirectory/acv/hefe.acv";
String LIGHT_PARADES = "-vf curves=psfile=$appDirectory/acv/light-parades.acv";
String LORD_KELVIN = "-vf curves=psfile=$appDirectory/acv/lord-kelvin.acv";
String NASHVILLE = "-vf curves=psfile=$appDirectory/acv/nashville.acv";
String OCEAN = "-vf curves=psfile=$appDirectory/acv/ocean.acv";
String PEACOCK = "-vf curves=psfile=$appDirectory/acv/peacock.acv";
String XPROII = "-vf curves=psfile=$appDirectory/acv/xpro.acv";

const List<String> ACV_FILENAMES = [
  '1977.acv',
  'afterglow.acv',
  'alice.acv',
  'ambers.acv',
  'blue-yellow.acv',
  'brannan.acv',
  'gotham.acv',
  'grading.acv',
  'hefe.acv',
  'light-parades.acv',
  'lord-kelvin.acv',
  'nashville.acv',
  'ocean.acv',
  'peacock.acv',
  'xpro.acv',
];
