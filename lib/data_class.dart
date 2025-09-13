class ClassAll {
  final Map<String, dynamic> class2 = {
    "1": ["Tiếng Việt", "Toán", "Đạo đức", "Giáo dục thể chất", "Âm nhạc", "Mĩ thuật", "Tự nhiên và Xã hội"],
    "2": ["Tiếng Việt", "Toán", "Đạo đức", "Giáo dục thể chất", "Âm nhạc", "Mĩ thuật", "Tự nhiên và Xã hội"],
    "3": ["Tiếng Việt", "Toán", "Ngoại ngữ 1", "Đạo đức", "Giáo dục thể chất", "Âm nhạc", "Mĩ thuật", "Tin học và Công nghệ", "Tự nhiên và Xã hội"],
    "4": ["Tiếng Việt", "Toán", "Ngoại ngữ 1", "Đạo đức", "Lịch sử và Địa lí", "Khoa học", "Tin học và Công nghệ", "Giáo dục thể chất", "Âm nhạc", "Mĩ thuật"],
    "5": ["Tiếng Việt", "Toán", "Ngoại ngữ 1", "Đạo đức", "Lịch sử và Địa lí", "Khoa học", "Tin học và Công nghệ", "Giáo dục thể chất", "Âm nhạc", "Mĩ thuật"],
    "6": ["Ngữ văn", "Toán", "Ngoại ngữ 1", "Giáo dục công dân", "Lịch sử và Địa lí", "Vật lí", "Hóa học", "Sinh học", "Tin học", "Công nghệ", "Giáo dục thể chất", "Âm nhạc", "Mĩ thuật"],
    "7": ["Ngữ văn", "Toán", "Ngoại ngữ 1", "Giáo dục công dân", "Lịch sử và Địa lí", "Vật lí", "Hóa học", "Sinh học", "Tin học", "Công nghệ", "Giáo dục thể chất", "Âm nhạc", "Mĩ thuật"],
    "8": ["Ngữ văn", "Toán", "Ngoại ngữ 1", "Giáo dục công dân", "Lịch sử và Địa lí", "Vật lí", "Hóa học", "Sinh học", "Tin học", "Công nghệ", "Giáo dục thể chất", "Âm nhạc", "Mĩ thuật"],
    "9": ["Ngữ văn", "Toán", "Ngoại ngữ 1", "Giáo dục công dân", "Lịch sử và Địa lí", "Vật lí", "Hóa học", "Sinh học", "Tin học", "Công nghệ", "Giáo dục thể chất", "Âm nhạc", "Mĩ thuật"],
    "10": ["Ngữ văn", "Toán", "Ngoại ngữ 1", "Lịch sử", "Giáo dục thể chất", "Giáo dục quốc phòng và an ninh","Địa lí", "Giáo dục kinh tế và pháp luật", "Vật lí", "Hóa học", "Sinh học", "Công nghệ", "Tin học", "Âm nhạc", "Mĩ thuật"],
    "11": ["Ngữ văn", "Toán", "Ngoại ngữ 1", "Lịch sử", "Giáo dục thể chất", "Giáo dục quốc phòng và an ninh","Địa lí", "Giáo dục kinh tế và pháp luật", "Vật lí", "Hóa học", "Sinh học", "Công nghệ", "Tin học", "Âm nhạc", "Mĩ thuật"],
    "12": ["Ngữ văn", "Toán", "Ngoại ngữ 1", "Lịch sử", "Giáo dục thể chất", "Giáo dục quốc phòng và an ninh","Địa lí", "Giáo dục kinh tế và pháp luật", "Vật lí", "Hóa học", "Sinh học", "Công nghệ", "Tin học", "Âm nhạc", "Mĩ thuật"]
  };

  /// Lấy danh sách môn theo lớp
  List<String> getSubjects(String grade) {
    final data = class2[grade];
    if (data == null) return [];
    if (data is List<String>) return List<String>.from(data);

    // Nếu là map (lớp 10-12), gộp bắt_buộc + lựa_chọn + tự_chọn
    if (data is Map<String, dynamic>) {
      final result = <String>[];
      result.addAll(List<String>.from(data["bắt_buộc"] ?? []));
      result.addAll(List<String>.from(data["lựa_chọn"] ?? []));
      result.addAll(List<String>.from(data["tự_chọn"] ?? []));
      return result;
    }
    return [];
  }

  /// Lấy riêng các môn bắt buộc của lớp 10-12
  List<String> getCompulsorySubjects(String grade) {
    final data = class2[grade];
    if (data is Map<String, dynamic>) {
      return List<String>.from(data["bắt_buộc"] ?? []);
    }
    return [];
  }
}
