class ConstService {
  static const urlMax = 512;

  static const roomSearchDefaultHour = -3;

  static const listStep = 20;
  static const stepTime = 15;

  static const userGreetingMax = 140;

  static const followMax = 100;
  static const blockMax = 20;

  static const joinRoomMax = 10;
  static const waitTimeMax = 50;
  static const calendarMax = 90;

  static const roomTitleMax = 20;
  static const roomDescriptionMax = 140;
  static const roomMaxNumber = 15;
  static const roomPasswordMax = 8;
  static const roomTagMax = 10;
  static const chatMaxNumber = 20;

  static const maxTagLength = 10;

  static const sampleTagsPlay = [
    '雑談',
    '声劇',
    '麻雀',
    'TRPG',
    'マダミス',
    'ボドゲ',
    'Minecraft',
    'AmongUs',
    'Apex',
    'マリカ',
    'スプラトゥーン',
    'スマブラ',
    '呑み',
  ];

  static const sampleTagsRoom = [
    ...sampleTagsPlay,
    '1hくらい',
    '2hくらい',
    '誰でもきてね',
    '初見もきてね',
    '10代',
    '20才以上',
    '配信あり',
  ];

  static const sampleTagsUser = [
    ...sampleTagsPlay,
    '♂',
    '♀',
    '1hくらい',
    '2hくらい',
    'お初でも誘って',
    '10代',
    '20代',
    '30代',
    '40代',
  ];
}
