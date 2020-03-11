package $package$.core.tools;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import org.apache.commons.lang3.StringUtils;

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class StringTools {

  // 第18位校验码，余数对应正确的末尾数字
  private static final Map<String, String> checkCodeMap = new HashMap<>();
  // 权重值，身份证的每一位，与对应次序的数字进行相乘
  private static final Integer[] factorArr = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2};
  // 省份编码
  private static final String cityCode[] = {
    "11", "12", "13", "14", "15", "21", "22", "23", "31", "32", "33", "34", "35", "36", "37", "41",
    "42", "43", "44", "45", "46", "50", "51", "52", "53", "54", "61", "62", "63", "64", "65", "71",
    "81", "82", "91"
  };

  static {
    // 初始化 各位与权重计算所得余数对应正确的末尾数字
    checkCodeMap.put("0", "1");
    checkCodeMap.put("1", "0");
    checkCodeMap.put("2", "Xx");
    checkCodeMap.put("3", "9");
    checkCodeMap.put("4", "8");
    checkCodeMap.put("5", "7");
    checkCodeMap.put("6", "6");
    checkCodeMap.put("7", "5");
    checkCodeMap.put("8", "4");
    checkCodeMap.put("9", "3");
    checkCodeMap.put("10", "2");
  }

  /**
   * 检查身份证号的正确性，可检查15位和18位两种身份证号，1900年以后
   *
   * @param idCard
   * @return
   */
  public static boolean checkIdCard(String idCard) {
    // 判断传参是否为空
    if (!StringTools.isNotEmpty(idCard)) {
      return false;
    }
    // 判断传参的位数是否正确
    if (idCard.length() != 15 && idCard.length() != 18) {
      return false;
    }
    // 检查身份证号字符串是否正确（只能是0-9，Xx）
    if (!checkIdCardString(idCard)) {
      return false;
    }
    // 如果idCard为15位，则先转换成18位身份证号
    if (idCard.length() == 15) {
      idCard = idCard15To18(idCard);
    }
    // 检查身份证的区域是否正确
    if (!checkIdCardArea(idCard)) {
      return false;
    }
    // 检查身份证的生日是否正确
    if (!checkIdCardBirthday(idCard)) {
      return false;
    }
    // 通过前17位数字及权重，获得第18位校验码
    int checkCode = getCheckCode18Bit(idCard);
    // 比较正确的校验码与输入的第18位字符，且当非老身份证号码时
    if (checkCodeMap.get(String.valueOf(checkCode)).indexOf(idCard.substring(17, 18)) < 0) {
      return false;
    }
    return true;
  }

  /**
   * 检查身份证号字符串是否正确（只能是0-9，Xx）
   *
   * @param idCard
   * @return true: 字符串正确，false:字符串格式错误
   */
  private static boolean checkIdCardString(String idCard) {
    boolean flag = false;
    // 18位时，前17位必须是全数字，最后一位是数字或Xx
    if (idCard.length() == 18) {
      flag = StringUtils.isNumeric(idCard.substring(0, 17));
      if (flag) {
        flag = "0123456789Xx".indexOf(idCard.substring(17, 18)) >= 0 ? true : false;
      }
    }
    // 15位时，必须是全数字
    else if (idCard.length() == 15) {
      flag = StringUtils.isNumeric(idCard);
    }
    return flag;
  }

  /**
   * 检查身份证的区域是否正确
   *
   * @param idCard
   * @return
   */
  private static boolean checkIdCardArea(String idCard) {
    if (!StringTools.isNotEmpty(idCard) || idCard.length() != 18) {
      return false;
    }
    String provinceid = idCard.substring(0, 2);
    boolean flag = false;
    for (String id : cityCode) {
      if (id.equals(provinceid)) {
        flag = true;
        break;
      }
    }
    return flag;
  }

  /**
   * 检查身份证的生日是否正确
   *
   * @param idCard
   * @return
   */
  private static boolean checkIdCardBirthday(String idCard) {
    if (!StringTools.isNotEmpty(idCard) || idCard.length() != 18) {
      return false;
    }
    int idCardYear = Integer.parseInt(idCard.substring(6, 10)); // 获得身份证的年
    int idCardMonth = Integer.parseInt(idCard.substring(10, 12)); // 获得身份证的月
    int idCardDay = Integer.parseInt(idCard.substring(12, 14)); // 获得身份证的日
    Calendar calendar = Calendar.getInstance();
    calendar.setTime(new Date());
    int nowYear = calendar.get(Calendar.YEAR);
    // 检查日期是否超出范围
    if (idCardYear > nowYear || idCardYear < 1900) {
      return false;
    }
    // 检查日期是否超出范围
    if (idCardMonth < 1 || idCardMonth > 12) {
      return false;
    }
    calendar.set(Calendar.YEAR, idCardYear);
    calendar.set(Calendar.MONTH, idCardMonth - 1);
    // 获取身份证号月份最大天数
    int lastDay = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
    // 检查日期是否超出范围
    if (idCardDay < 1 || idCardDay > lastDay) {
      return false;
    }
    return true;
  }

  /**
   * 15位身份证号转18位，权支持1900年之后的15位身份证
   *
   * @param idCard15
   * @return
   */
  private static String idCard15To18(String idCard15) {
    String idCard17 = idCard15.substring(0, 6) + "19" + idCard15.substring(6);
    return idCard17 + checkCodeMap.get(String.valueOf(getCheckCode18Bit(idCard17))).substring(0, 1);
  }

  /**
   * 通过前17位数字及权重，获得第18位校验码
   *
   * @param idCard 至少17位
   * @return
   */
  private static int getCheckCode18Bit(String idCard) {
    idCard = idCard.substring(0, 17);
    String[] idCardNumAry = idCard.split("");
    int countSum = 0; // 前17位数字与权重值乘积的和
    int checkCode = 0;
    // 只记入前17位数字与权重值乘积的和
    for (int i = 0; i < 17; i++) {
      countSum += Integer.parseInt(idCardNumAry[i]) * factorArr[i];
    }
    // 前17位数字与对应权重值的乘积和 除以 11 的余数,即最后一位校验码
    checkCode = countSum % 11;
    return checkCode;
  }

  // 身份证号码验证 end

  /**
   * 生成随机数
   *
   * @return
   */
  public static String getRandomString() {
    int random = new Random().nextInt(10000);
    String str = Long.toString(System.currentTimeMillis()) + random;
    return str;
  }

  /**
   * 验证邮箱
   *
   * @param email
   * @return
   */
  public static boolean checkEmail(String email) {
    boolean flag = false;
    try {
      String check =
          "^([a-z0-9A-Z]+[-|_|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$";
      Pattern regex = Pattern.compile(check);
      Matcher matcher = regex.matcher(email);
      flag = matcher.matches();
    } catch (Exception e) {
      flag = false;
    }
    return flag;
  }

  /**
   * 验证手机号码
   *
   * @param mobileNumber
   * @return true 代表符合手机，fasle不符合
   */
  public static boolean checkMbl(String mobileNumber) {
    boolean flag = false;
    try {
      Pattern regex = Pattern.compile("^1\\d{10}$");
      Matcher matcher = regex.matcher(mobileNumber);
      flag = matcher.matches();
    } catch (Exception e) {
      flag = false;
    }
    return flag;
  }

  /**
   * 验证是否是英文
   *
   * @param str 被验证字符串
   * @return true 只是英文；false:不只是英文
   */
  public static boolean checkEnlish(String str) {
    boolean flag = false;
    try {
      Pattern regex = Pattern.compile("^[a-zA-Z]+$");
      Matcher matcher = regex.matcher(str);
      flag = matcher.matches();
    } catch (Exception e) {
      flag = false;
    }
    return flag;
  }

  /**
   * 判断字符串不为空
   *
   * @param str
   * @return boolean
   */
  public static boolean isNotEmpty(String str) {
    boolean flag = true;
    if (str == null) {
      flag = false;
    } else if (str.trim().length() < 1) {
      flag = false;
    }
    return flag;
  }

  /**
   * 判断字符串为空
   *
   * @param str
   * @return boolean
   */
  public static boolean isEmpty(String str) {
    return !isNotEmpty(str);
  }

  /** 去除Hql or Sql的select 子句，未考虑union的情况 */
  public static String removeSelectToPageQuery(String shql) {
    int beginPos = shql.toLowerCase().indexOf("from");
    return shql.substring(beginPos);
  }

  /** 去除Hql or Sql的orderby 子句 */
  public static String removeOrdersToPageQuery(String shql) {
    // 匹配正则表达式必须使用的是'\\'，而不是'//'
    Pattern p = Pattern.compile("order\\s*by\\s*[\\w|\\W|\\s|\\S]*", Pattern.CASE_INSENSITIVE);
    Matcher m = p.matcher(shql);
    StringBuffer sb = new StringBuffer();
    while (m.find()) {
      m.appendReplacement(sb, "");
    }
    m.appendTail(sb);
    return sb.toString();
  }

  /**
   * 转义正则特殊字符 （$()*+.[]?\^{},|）
   *
   * @param keyword
   * @return
   */
  public static String escapeExprSpecialWord(String keyword) {
    if (StringUtils.isNotBlank(keyword)) {
      String[] fbsArr = {
        "\\", "$", "(", ")", "*", "+", ".", "[", "]", "?", "^", "{", "}", "|", "'", "\""
      };
      for (String key : fbsArr) {
        if (keyword.contains(key)) {
          keyword = keyword.replace(key, "\\" + key);
        }
      }
    }
    return keyword;
  }

  /**
   * 转义sql特殊字符
   *
   * @param keyword
   * @return
   */
  public static String escapSqlSpecialWord(String keyword) {
    if (StringUtils.isNotBlank(keyword)) {
      String[] fbsArr = {
        "\\", "$", "(", ")", "*", "+", ".", "[", "]", "?", "^", "{", "}", "|", "'", "\"", "\b",
        "\n", "\t", "\f"
      };
      for (String key : fbsArr) {
        if (keyword.contains(key)) {
          keyword = keyword.replace(key, "\\" + key);
        }
      }
    }
    return keyword;
  }

  /**
   * 封装模糊搜索的关键字
   *
   * @param keywords
   * @param keys
   * @return
   */
  public static String packkeywords(String keywords, Object... keys) {
    if (StringUtils.isBlank(keywords)) return null;
    if (keys == null) return null;
    keywords = StringTools.escapSqlSpecialWord(keywords);
    StringBuffer sqlsb = new StringBuffer();
    sqlsb.append(" 1=2 ");
    for (Object key : keys) {
      sqlsb.append(" or ");
      sqlsb.append(key + " like '%" + keywords + "%'");
    }
    return sqlsb.toString();
  }

  /**
   * 对象合并（用于属性为空时合并，不相互覆盖）
   *
   * <p>例如： oldObj :{"a":"aaaa","b":"ccccccccc"} 向 newObj: {"a":null,"b":"bbbbb"} 合并 结果： return
   * :{"a":"aaaa","b":"bbbbb"}
   *
   * @param newObj 最终获得对象
   * @param oldObj 数据携带对象
   * @param clazz 最终获得对象类型
   * @return 最终获得对象
   */
  public static <T> T mergeObject(Object newObj, Object oldObj, Class<T> clazz) {
    Map newMap = (Map) JSON.toJSON(newObj);
    Map oldMap = (Map) JSON.toJSON(oldObj);
    for (Object key : newMap.keySet()) {
      if (newMap.get(key) == null && oldMap.containsKey(key) && oldMap.get(key) != null) {
        newMap.put(key, oldMap.get(key));
      }
    }
    return JSON.parseObject(JSON.toJSONString(newMap), clazz);
  }

  /**
   * 将对像转化为需要的类型
   *
   * @param obj 需要转化对象
   * @param calsz 转化结果
   * @return
   */
  public static <T> T convertObject(Object obj, Class<T> calsz) {
    String json = JSON.toJSONString(obj);
    return JSON.parseObject(json, calsz);
  }

  /**
   * map转化为json字符串
   *
   * @param map 需要转换的map
   * @return String 返回的字符串
   */
  public static String mapToJsonStr(Map<String, Object> map) {
    return map.size() > 0 ? JSONObject.toJSON(map).toString() : null;
  }

  /**
   * 将集合转化为需要的类型
   *
   * @param obj 需要转化对象
   * @param calsz 转化结果
   * @return
   */
  public static <T> List<T> convertList(Object obj, Class<T> calsz) {
    String json = JSON.toJSONString(obj);
    return JSON.parseArray(json, calsz);
  }

  // cn -> unicode
  public static String Cn2UniCode(String string) {
    StringBuffer sb = new StringBuffer();
    char[] charArray = string.toCharArray();
    for (char ch : charArray) {
      if (ch > 255) {
        String str = Integer.toHexString(ch);
        if (str.length() == 1) {
          sb.append("\\u000" + str);
        } else if (str.length() == 2) {
          sb.append("\\u00" + str);
        } else if (str.length() == 3) {
          sb.append("\\u0" + str);
        } else if (str.length() == 4) {
          sb.append("\\u" + str);
        }
      } else {
        sb.append(ch);
      }
    }
    return sb.toString();
  }

  // Unicode -> Cn
  public static String Unicode2Cn(String theString) {
    char aChar;
    int len = theString.length();
    StringBuffer outBuffer = new StringBuffer(len);
    for (int x = 0; x < len; ) {
      aChar = theString.charAt(x++);
      if (aChar == '\\') {
        aChar = theString.charAt(x++);
        if (aChar == 'u') {
          int value = 0;
          for (int i = 0; i < 4; i++) {
            aChar = theString.charAt(x++);
            switch (aChar) {
              case '0':
              case '1':
              case '2':
              case '3':
              case '4':
              case '5':
              case '6':
              case '7':
              case '8':
              case '9':
                value = (value << 4) + aChar - '0';
                break;
              case 'a':
              case 'b':
              case 'c':
              case 'd':
              case 'e':
              case 'f':
                value = (value << 4) + 10 + aChar - 'a';
                break;
              case 'A':
              case 'B':
              case 'C':
              case 'D':
              case 'E':
              case 'F':
                value = (value << 4) + 10 + aChar - 'A';
                break;
              default:
                throw new IllegalArgumentException("Malformed      encoding.");
            }
          }
          outBuffer.append((char) value);
        } else {
          if (aChar == 't') {
            aChar = '\t';
          } else if (aChar == 'r') {
            aChar = '\r';
          } else if (aChar == 'n') {
            aChar = '\n';
          } else if (aChar == 'f') {
            aChar = '\f';
          }
          outBuffer.append(aChar);
        }
      } else {
        outBuffer.append(aChar);
      }
    }
    return outBuffer.toString();
  }

  /**
   * 获取domain域名
   *
   * @param url request.getRequestURL()
   * @param uri request.getRequestURI()
   * @return
   */
  public static String getDomain(StringBuffer url, String uri) {
    if (url == null || StringUtils.isBlank(url.toString()) || StringUtils.isBlank(uri)) {
      return null;
    }
    return url.delete(url.length() - uri.length(), url.length())
        .toString()
        .replace("http://", "")
        .replace("https://", "");
  }
}
