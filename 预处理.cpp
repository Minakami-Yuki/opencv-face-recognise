#include <iostream>
#include <string>
#include <opencv2\opencv.hpp>
#include <opencv2\core\core.hpp>
#include "Windows.h"
#include "mmsystem.h"
#include <dsound.h>
#pragma comment(lib,"WinMM.Lib")
#pragma comment(linker,"/SUBSYSTEM:Windows  /ENTRY:mainCRTStartup")
using namespace cv;
using namespace std;
int main()
{
	PlaySound(TEXT("AY_sys10.wav"), NULL, SND_FILENAME | SND_ASYNC);
	CascadeClassifier faceDetcter;
	vector<Rect> faces;
	string faceCascadeFilename = "haarcascade_frontalface_alt2.xml";
	faceDetcter.load(faceCascadeFilename);
	for (int i = 1; i <= 10; i++)
	{
		string picname = format("%d.jpg", i);
//		cout << picname << endl;
		Mat frame = imread(picname);

		Mat frame_gray;
		cvtColor(frame, frame_gray, COLOR_BGR2GRAY);
		
//		equalizeHist(frame_gray, frame_gray);
//		imshow("grey", frame_gray);
//		waitKey(5000);
		faceDetcter.detectMultiScale(frame_gray, faces, 1.1, 3, CV_HAAR_DO_ROUGH_SEARCH, Size(50, 50));
		for (size_t j = 0; j < faces.size(); j++)
		{
			Mat faceROI = frame_gray(faces[j]);
			Mat MyFace;
			if (faceROI.cols > 100)
			{
				resize(faceROI, MyFace, Size(92, 112));
				string  str = format("%d.pgm", i);
				imwrite(str, MyFace);
				imshow("ii", MyFace);
			}
			waitKey(2000);
//			rectangle(frame_gray, faces[i], Scalar(255, 255, 0), 2, 8, 0);
//			cout << "program run here\n";
		}
//		imshow("test", frame_gray);
//		waitKey(2000);
	}
	//exception occured!!!!!!!!!ntdll.dll 0xC0000005?????????????
//	PlaySound(TEXT("AY_sys11.wav"), NULL, SND_FILENAME | SND_ASYNC);
	return 0;
}