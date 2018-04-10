#include <opencv2\opencv.hpp>
#include <opencv2\face.hpp>
#include <iostream>
#include <fstream>
#include <sstream>
#include <cmath>
#pragma comment(linker,"/SUBSYSTEM:Windows  /ENTRY:mainCRTStartup")
using namespace cv;
using namespace std;
//using namespace face;
int main()
{
	vector<Mat> images;
	vector<int> labels;
	int num = 1; double threshold = 10.0;
	Ptr<face::EigenFaceRecognizer> model = face::EigenFaceRecognizer::create();
	for (int i = 1; i <= 10; i++)
	{
		string picname = format("%d.pgm", i);
		Mat src = imread(picname);
		imshow("test", src);
		waitKey(2000);
//		resize(src, src, Size(128, 128));
		images.push_back(src);
		labels.push_back(1);
		model->train(images, labels);
	}
	model->save("my_face_test.xml");
	return 0;
}