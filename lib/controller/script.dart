import 'dart:convert';
import 'package:flutter/material.dart';

Image strToImage(String image){
  Image output;
  try {
    output = new Image.memory(base64Decode(image));
  }
  catch (e) {
    output = null;
    print(e);
  }
  return output;
}