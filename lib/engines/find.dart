part of 'engine.dart';

Map<String, dynamic> filter(Map<String, dynamic> object, List<String> keys) {
  final result = <String, dynamic>{};
  object.keys.forEach((key) {
    if (keys.contains(key)) {
      result[key] = object[key];
    }
  });
  return result;
}

List<String> limit(String text) {
  final output = <String>[text[0]];
  int length() {
    var sum = 0;
    output.forEach((token) {
      sum += token.length;
    });
    return sum;
  }

  text.substring(1).split('').where((token) {
    if (length() > 15) {
      return true;
    }
    output.add(token);
    return false;
  });
  return output;
}

Map<String, dynamic> getFormatData(Map<String, dynamic> data) {
  try {
    final info = filter(data, ['id', 'name', 'alias', 'duration']);
    info['name'] = (info['name'] ?? '')
        .replaceAll(RegExp(r'（\s*cover[:：\s][^）]+）', caseSensitive: false), '')
        .replaceAll(RegExp(r'\(\s*cover[:：\s][^)]+\)', caseSensitive: false), '')
        .replaceAll(RegExp(r'（\s*翻自[:：\s][^）]+）', caseSensitive: false), '')
        .replaceAll(RegExp(r'\(\s*翻自[:：\s][^)]+\)', caseSensitive: false), '');
    info['album'] = filter(data['album'], ['id', 'name']);
    info['artists'] = data['artists'].map((artist) => filter(artist, ['id', 'name']));
    info['keyword'] =
        info['name'] + ' - ' + limit(info['artists'].map((artist) => artist['name']).join(' / ')).join('');
    if (true) {
      // TODO: SEARCH_ALBUM
      final album = info['album']['name'];
      if (album != null && album != info['name']) {
        info['keyword'] += ' $album';
      }
    }
    return info;
  } catch (err) {
    print('getFormatData err: $err');
    return {};
  }
}

// https://music.163.com/api/song/detail?ids=[123456]
/*
{"songs":[{"name":"爱","id":123456,"position":4,"alias":[],"status":0,"fee":0,"copyrightId":0,"disc":"1","no":4,"artists":[{"name":"刘罡","id":3774,"picId":0,"img1v1Id":0,"briefDesc":"","picUrl":"https://p2.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpg","img1v1Url":"https://p2.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpg","albumSize":0,"alias":[],"trans":"","musicSize":0,"topicPerson":0}],"album":{"name":"二人传奇","id":11935,"type":"专辑","size":11,"picId":83562883711712,"blurPicUrl":"https://p2.music.126.net/K9f4Ec2AR5HwDMChCb5_9Q==/83562883711712.jpg","companyId":0,"pic":83562883711712,"picUrl":"https://p2.music.126.net/K9f4Ec2AR5HwDMChCb5_9Q==/83562883711712.jpg","publishTime":1101830400000,"description":"","tags":"","company":"佰度唱片","briefDesc":"","artist":{"name":"","id":0,"picId":0,"img1v1Id":0,"briefDesc":"","picUrl":"https://p2.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpg","img1v1Url":"https://p2.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpg","albumSize":0,"alias":[],"trans":"","musicSize":0,"topicPerson":0},"songs":[],"alias":[],"status":1,"copyrightId":0,"commentThreadId":"R_AL_3_11935","artists":[{"name":"刘罡","id":3774,"picId":0,"img1v1Id":0,"briefDesc":"","picUrl":"https://p2.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpg","img1v1Url":"https://p2.music.126.net/6y-UleORITEDbvrOLV0Q8A==/5639395138885805.jpg","albumSize":0,"alias":[],"trans":"","musicSize":0,"topicPerson":0}],"subType":"录音室版","transName":null,"onSale":false,"mark":0,"gapless":0,"dolbyMark":0},"starred":false,"popularity":10.0,"score":10,"starredNum":0,"duration":248006,"playedNum":0,"dayPlays":0,"hearTime":0,"sqMusic":null,"hrMusic":null,"ringtone":"","crbt":null,"audition":null,"copyFrom":"","commentThreadId":"R_SO_4_123456","rtUrl":null,"ftype":0,"rtUrls":[],"copyright":2,"transName":null,"sign":null,"mark":0,"originCoverType":0,"originSongSimpleData":null,"single":0,"noCopyrightRcmd":null,"hMusic":null,"mMusic":{"name":"爱","id":28864980,"size":4983586,"extension":"mp3","sr":44100,"dfsId":0,"bitrate":160000,"playTime":248006,"volumeDelta":0.482621},"lMusic":{"name":"爱","id":28864981,"size":2999116,"extension":"mp3","sr":44100,"dfsId":0,"bitrate":96000,"playTime":248006,"volumeDelta":0.324618},"bMusic":{"name":"爱","id":28864981,"size":2999116,"extension":"mp3","sr":44100,"dfsId":0,"bitrate":96000,"playTime":248006,"volumeDelta":0.324618},"mvid":0,"mp3Url":null,"rtype":0,"rurl":null}],"equalizers":{},"code":200}
 */
Future<Map<String, dynamic>?> find(int id, Map<String, dynamic> data) {
  if (data != null) {
    final info = getFormatData(data);
    if (info['name'] != null) {
      return Future.value(info);
    } else {
      return Future.value(null);
    }
  } else {
    final url = 'https://music.163.com/api/song/detail?ids=[$id]';
    return request('GET', url)
        // .then((response) => response.json())
        .then((jsonBody) {
      if (jsonBody != null && jsonBody['songs'] != null && jsonBody['songs'].length > 0) {
        final info = getFormatData(jsonBody['songs'][0]);
        if (info['name'] != null) {
          return info;
        } else {
          return null;
        }
      } else {
        return null;
      }
    });
  }
}

// request
Future<Map<String, dynamic>> request(String method, String url) {
  throw UnimplementedError();
}
