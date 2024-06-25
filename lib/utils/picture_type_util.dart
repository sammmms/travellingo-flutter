enum PictureType { link, file, base64 }

class PictureTypeUtil {
  static const Map<PictureType, String> _pictureTypeMap = {
    PictureType.link: 'Link',
    PictureType.file: 'File',
    PictureType.base64: 'Base64'
  };

  static String stringOf(PictureType pictureType) {
    return _pictureTypeMap[pictureType]!;
  }

  static PictureType typeOf(String pictureType) {
    return _pictureTypeMap.entries
        .firstWhere((element) => element.value.toLowerCase() == pictureType)
        .key;
  }
}
