#include <iostream>
#include <opencv2/opencv.hpp>
#include <opencv2\face.hpp>
//#include "mmsystem.h"
#include "Windows.h"
#pragma comment(lib,"WinMM.Lib")
#pragma comment(linker,"/SUBSYSTEM:Windows  /ENTRY:mainCRTStartup")
using namespace std;
using namespace cv;
using namespace face;
int main()
{
	PlaySound("NA_sys10.wav", NULL, SND_FILENAME | SND_ASYNC);
	VideoCapture cap(0);
//	VideoCapture cap(1);
	Mat flame,flamee;
//	char key;

//	CascadeClassifier cascade;
//	cascade.load("haarcascade_frontalface_alt2.xml");
	
	int i = 1;
	while (1)
	{
		char key = waitKey(100);
		string filename = format("%d.jpg", i);
		string countn = format("%d.png", i);
		Mat count = imread(countn,0);
		Mat county = imread(countn);
//		imshow("tets", count);
		threshold(count, count, 254, 255, CV_THRESH_BINARY);
		Mat mask1 = 255 - count;
//		Mat mask1 = count;
		cap >> flamee;
		flamee.copyTo(flame);
		Mat addtest = flame(Rect(0,0,count.cols,count.rows));
		county.copyTo(addtest, mask1);
//		addWeighted(flame, 0.5, count, 0.5, 0, addtest);//need same size??????
		imshow("frame", flame);
		switch (key)
		{
		case'p':
			PlaySound("menuback.wav", NULL, SND_FILENAME | SND_ASYNC);
			i++;
			cout << i << endl;
			imwrite(filename, flamee);
			imshow("photo", flamee);
			waitKey(500);
			destroyWindow("photo");
			break;
		default:
			break;
		}
//		if (i == 10) PlaySound("NA_sys2.wav", NULL, SND_FILENAME | SND_ASYNC);//always loop!!!
		if (i == 11) break; 
	}
	//exceptions!!!!!unsolved!!!!!!!
	destroyWindow("flame");
	ReleaseCapture();
	PlaySound("NA_sys2.wav", NULL, SND_FILENAME | SND_ASYNC);
	return 0;
}