#include <iostream>
#include <fstream>
#include <opencv2\opencv.hpp>
#include <opencv2\face.hpp>
#pragma comment(linker,"/SUBSYSTEM:Windows  /ENTRY:mainCRTStartup")
using namespace std;
using namespace cv;
using namespace face;
int main()
{
	VideoCapture cap(0);
	Mat frame;
	Mat gray;
	ofstream out("result.txt");
//	waitKey(100);
	int output[100];
	for (int tmp = 0; tmp < 100; tmp++)
		output[tmp] = 0;
	output[0] = 1;
	CascadeClassifier cascade;
	cascade.load("haarcascade_frontalface_alt2.xml");
	Ptr<EigenFaceRecognizer> model = EigenFaceRecognizer::create();
	model->read("my_face_test.xml");
	while (1)
	{
		cap >> frame;
//		imshow("test", frame);
//		waitKey(300);
		vector<Rect> faces(0);
		cvtColor(frame, gray, CV_BGR2GRAY);
		cascade.detectMultiScale(gray, faces, 1.1, 3, CV_HAAR_DO_ROUGH_SEARCH, Size(50, 50));
		Mat face;
		Point text;
		for (size_t i = 0; i < faces.size(); i++)
		{
			if (faces[i].width > 0 && faces[i].height > 0)
			{
				face = gray(faces[i]);
				text = Point(faces[i].x, faces[i].y);
				rectangle(frame, faces[i], Scalar(255, 0, 0), 1, 8, 0);
			//	imshow("test-bp1", frame);
			//	waitKey(300);
			}
		}
		Mat face_test;
		if (face.rows >= 120)
			resize(face, face_test, Size(92, 112));
		int predict = 0;
		if (!face_test.empty())
			predict = model->predict(face_test);
		//cout << predict << endl;
		if (predict == 1)
		{
			if (output[predict] == 0)
			{
				cout << "person1" << endl;
				out << "person1";
			}
			output[predict] = 1;
			string name = "  person1";
			putText(frame, name, text, FONT_HERSHEY_COMPLEX, 1, Scalar(0, 0, 255));
		}
		imshow("window", frame);
		//waitKey(200);
		char key = waitKey(100);
		switch (key)
		{
		case'q':
			out.close();
			exit(1);
			break;
		default:
			break;
		}
	}
	out.close();
	return 0;
}