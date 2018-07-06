#include <iostream>
#include <fstream>
#include <sstream>
#include "Matrix.h"
#include "Image.h"
#include "processing.h"
#include "unit_test_framework.h"

using namespace std;


//REQUIRES: mat points to a valid Matrix; arr points to a valid int array
//MODIFIES: nothing
//EFFECTS: Returns true if the two arrays are the same, false if otherwise
bool compare_matrix_data_with_arr(const Matrix* mat, const int* arr, int size) {
    if(Matrix_width(mat) * Matrix_height(mat) != size) { return false; } //first compare sizes of the arrays
    else {
        for(int i = 0; i < size; i++) {
            if(*Matrix_at(mat, 0, 0) != arr[i]) { return false; }
        }
    }
    return true;
}

TEST(Matrix_init) {
    Matrix m;
    Matrix_init(&m, 67, 80);
    ASSERT_TRUE(Matrix_width(&m) == 67 && Matrix_height(&m) == 80);
}

TEST(Matrix_fill) {
    Matrix m;
    Matrix_init(&m, 3, 5);
    Matrix_fill(&m, 2);
    int arr[15] = {2, 2, 2,
                   2, 2, 2,
                   2, 2, 2,
                   2, 2, 2,
                   2, 2, 2};
    ASSERT_TRUE(compare_matrix_data_with_arr(&m, arr, 15));
}

TEST(Matrix_at) {
    Matrix m;
    Matrix_init(&m, 3, 5);
    int count = 0;
    for(int i = 0; i < Matrix_width(&m); i++) {
        for(int j = Matrix_height(&m) - 1; j >= 0; j--) {
            *Matrix_at(&m, j, i) = count++;
        }
    }
    int arr[15] = {4, 9, 14,
                   3, 8, 13,
                   2, 7, 12,
                   1, 6, 11,
                   0, 5, 10};
    ASSERT_TRUE(compare_matrix_data_with_arr(&m, arr, 15));
}

TEST(Matrix_width) {
    Matrix m;
    Matrix_init(&m, 34, 29);
    ASSERT_EQUAL(Matrix_width(&m), 34);
}

TEST(Matrix_height) {
    Matrix m;
    Matrix_init(&m, 34, 29);
    ASSERT_EQUAL(Matrix_height(&m), 29);
}

TEST(Matrix_print) {
    Matrix m;
    Matrix_init(&m, 3, 3);
    Matrix_fill(&m, 2);
    Matrix_fill_border(&m, 1);
    stringstream ss;
    Matrix_print(&m, ss);
    string output;
    string expected[] = {"3", "3",
                         "1", "1", "1",
                         "1", "2", "1",
                         "1", "1", "1"};
    int count = 0;
    while(ss >> output) {
        ASSERT_EQUAL(output, expected[count++]);
    }
}

TEST(Matrix_row) {
    Matrix m;
    Matrix_init(&m, 15, 23);
    ASSERT_EQUAL(Matrix_row(&m, Matrix_at(&m ,4, 13)), 4);
    ASSERT_EQUAL(Matrix_row(&m, Matrix_at(&m, 22, 14)), 22);
    ASSERT_EQUAL(Matrix_row(&m, Matrix_at(&m, 0, 0)), 0);
}

TEST(Matrix_column) {
    Matrix m;
    Matrix_init(&m, 15, 23);
    ASSERT_EQUAL(Matrix_column(&m, Matrix_at(&m, 4, 13)), 13);
    ASSERT_EQUAL(Matrix_column(&m, Matrix_at(&m, 22, 14)), 14);
    ASSERT_EQUAL(Matrix_column(&m, Matrix_at(&m, 0, 0)), 0);
}

TEST(Matrix_fill_border) {
    Matrix m;
    Matrix_init(&m, 3, 5);
    int count = 0;
    for(int i = 0; i < Matrix_width(&m); i++) {
        for(int j = Matrix_height(&m) - 1; j >= 0; j--) {
            *Matrix_at(&m, j, i) = count++;
        }
    }
    Matrix_fill_border(&m, 4);
    int arr[15] = {4, 4, 4,
                   4, 8, 4,
                   4, 7, 4,
                   4, 6, 4,
                   4, 4, 4};
    ASSERT_TRUE(compare_matrix_data_with_arr(&m, arr, 15));
}

TEST(Matrix_max) {
    Matrix m;
    Matrix_init(&m, 18, 57);
    Matrix_fill(&m, 3);
    ASSERT_EQUAL(Matrix_max(&m), 3);
    *Matrix_at(&m, 4, 5) = 5;
    ASSERT_EQUAL(Matrix_max(&m), 5);
    *Matrix_at(&m, 44, 17) = -2;
    *Matrix_at(&m, 7, 13) = 6;
    ASSERT_EQUAL(Matrix_max(&m), 6);
}

TEST(Matrix_column_of_min_value_in_row) {
    Matrix m;
    Matrix_init(&m, 3, 4);
    Matrix_fill(&m, 10);
    ASSERT_EQUAL(Matrix_column_of_min_value_in_row(&m, 3, 1, 3), 1);
    *Matrix_at(&m, 0, 2) = 3;
    ASSERT_EQUAL(Matrix_column_of_min_value_in_row(&m, 0, 0, 3), 2);
    *Matrix_at(&m, 2, 1) = -2;
    *Matrix_at(&m, 2, 2) = 5;
    ASSERT_EQUAL(Matrix_column_of_min_value_in_row(&m, 2, 0, 3), 1);
    ASSERT_EQUAL(Matrix_column_of_min_value_in_row(&m, 2, 0, 1), 0);
}

TEST(Matrix_min_value_in_row) {
    Matrix m;
    Matrix_init(&m, 3, 4);
    Matrix_fill(&m, 10);
    ASSERT_EQUAL(Matrix_min_value_in_row(&m, 3, 1, 3), 10);
    *Matrix_at(&m, 0, 2) = -5;
    ASSERT_EQUAL(Matrix_min_value_in_row(&m, 0, 0, 3), -5);
    *Matrix_at(&m, 2, 1) = -7;
    *Matrix_at(&m, 2, 2) = 3;
    ASSERT_EQUAL(Matrix_min_value_in_row(&m, 2, 0, 3), -7);
    ASSERT_EQUAL(Matrix_min_value_in_row(&m, 2, 0, 1), 10);
}

TEST(Image_init) {
    Image image1;    //Manual Initialization
    Image_init(&image1, 54, 65);
    ASSERT_EQUAL(image1.width, 54);
    ASSERT_EQUAL(image1.height, 65);
    ASSERT_EQUAL(Matrix_width(&image1.red_channel), 54);
    ASSERT_EQUAL(Matrix_width(&image1.green_channel), 54);
    ASSERT_EQUAL(Matrix_width(&image1.blue_channel), 54);
    ASSERT_EQUAL(Matrix_height(&image1.red_channel), 65);
    ASSERT_EQUAL(Matrix_height(&image1.green_channel), 65);
    ASSERT_EQUAL(Matrix_height(&image1.blue_channel), 65);

    Image image2;
    string filename = "dog.ppm";
    ifstream fin;
    fin.open(filename);
    if(!fin.is_open()) {
        cout << "Error opening file: " << filename << endl;
        exit(1);
    }
    Image_init(&image2, fin);
    stringstream ss;
    Image_print(&image2, ss);
    string output;
    string expected[] = {"P3", "5", "5", "255",
                         "0", "0", "0", "0", "0", "0", "255", "255", "250", "0", "0", "0", "0", "0", "0",
                         "255", "255", "250", "126", "66", "0", "126", "66", "0", "126", "66", "0", "255", "255", "250",
                         "126", "66", "0", "0", "0", "0", "255", "219", "183", "0", "0", "0","126", "66", "0",
                         "255", "219", "183", "255", "219", "183", "0", "0", "0", "255", "219", "183", "255", "219", "183",
                         "255", "219", "183", "0", "0", "0", "134", "0", "0", "0", "0", "0", "255", "219", "183"};
    int count = 0;
    while(ss >> output) {
        ASSERT_EQUAL(output, expected[count++]);
    }
    fin.close();
}

TEST(Image_width) {
    Image image1;
    Image_init(&image1, 4, 7);
    ASSERT_EQUAL(Image_width(&image1), 4);
}

TEST(Image_height) {
    Image image1;
    Image_init(&image1, 4, 7);
    ASSERT_EQUAL(Image_height(&image1), 7);
}

TEST(Image_get_pixel) {
    Image image;
    string filename = "dog.ppm";
    ifstream fin;
    fin.open(filename);
    if(!fin.is_open()) {
        cout << "Error opening file: " << filename << endl;
        exit(1);
    }
    Image_init(&image, fin);
    ASSERT_EQUAL(Image_get_pixel(&image, 0, 2).r, 255);
    ASSERT_EQUAL(Image_get_pixel(&image, 0, 2).g, 255);
    ASSERT_EQUAL(Image_get_pixel(&image, 0, 2).b, 250);
    fin.close();
}

TEST(Image_set_pixel) {
    Image image;
    string filename = "dog.ppm";
    ifstream fin;
    fin.open(filename);
    if(!fin.is_open()) {
        cout << "Error opening file: " << filename << endl;
        exit(1);
    }
    Image_init(&image, fin);
    Pixel color;
    color.r = 34;
    color.g = 255;
    color.b = 0;
    Image_set_pixel(&image, 3, 2, color);
    ASSERT_EQUAL(Image_get_pixel(&image, 3, 2).r, 34);
    ASSERT_EQUAL(Image_get_pixel(&image, 3, 2).g, 255);
    ASSERT_EQUAL(Image_get_pixel(&image, 3, 2).b, 0);
    fin.close();
}

TEST(Image_fill) {
    Image image;
    Image_init(&image, 3, 4);
    Pixel color;
    color.r = 0;
    color.g = 30;
    color.b = 250;
    Image_fill(&image, color);
    int expected[3][12] = {{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
                           {30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30},
                           {250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250, 250}};
    ASSERT_TRUE(compare_matrix_data_with_arr(&image.red_channel, expected[0], 12));
    ASSERT_TRUE(compare_matrix_data_with_arr(&image.green_channel, expected[1], 12));
    ASSERT_TRUE(compare_matrix_data_with_arr(&image.blue_channel, expected[2], 12));
}

TEST(compute_energy_matrix) {
    Image image;
    string filename = "dog.ppm";
    ifstream fin;
    fin.open(filename);
    if(!fin.is_open()) {
        cout << "Error opening file: " << filename << endl;
        exit(1);
    }
    Image_init(&image, fin);
    Matrix energy;
    Matrix_init(&energy, 5, 5);
    compute_energy_matrix(&image, &energy);
    int expected[] = {1470, 1470, 1470, 1470, 1470,
                       1470, 1148, 57, 1148, 1470,
                       1470, 1470, 202, 1470, 1470,
                       1470, 1464, 960, 1464, 1470,
                       1470, 1470, 1470, 1470, 1470};
    ASSERT_TRUE(compare_matrix_data_with_arr(&energy, expected, 25));
    fin.close();
}

TEST(compute_vertical_cost_matrix) {
    Image image;
    string filename = "dog.ppm";
    ifstream fin;
    fin.open(filename);
    if(!fin.is_open()) {
        cout << "Error opening file: " << filename << endl;
        exit(1);
    }
    Image_init(&image, fin);
    Matrix energy, cost;
    Matrix_init(&energy, 5, 5);
    compute_energy_matrix(&image, &energy);
    compute_vertical_cost_matrix(&energy, &cost);
    stringstream ss;
    Matrix_print(&cost, ss);
    string expected[] = {"5", "5",
                         "1470", "1470", "1470", "1470", "1470",
                         "2940", "2618", "1527", "2618", "2940",
                         "4088", "2997", "1729", "2997", "4088",
                         "4467", "3193", "2689", "3193", "4467",
                         "4663", "4159", "4159", "4159", "4663"};
    string output;
    int count = 0;
    while(ss >> output) {
        ASSERT_EQUAL(output, expected[count++]);
    }
    fin.close();
}

TEST(find_minimal_vertical_seam) {
    Image image;
    string filename = "dog.ppm";
    ifstream fin;
    fin.open(filename);
    if(!fin.is_open()) {
        cout << "Error opening file: " << filename << endl;
        exit(1);
    }
    Image_init(&image, fin);
    Matrix energy, cost;
    Matrix_init(&energy, 5, 5);
    compute_energy_matrix(&image, &energy);
    compute_vertical_cost_matrix(&energy, &cost);
    int seam[Matrix_height(&cost)], expected[] = {1, 2, 2, 2, 1};
    find_minimal_vertical_seam(&cost, seam);
    for(int i = 0; i < 5; i++) {
        ASSERT_EQUAL(seam[i], expected[i]);
    }
    fin.close();
}

TEST(remove_vertical_seam) {
    Image image;
    string filename = "dog.ppm";
    ifstream fin;
    fin.open(filename);
    if(!fin.is_open()) {
        cout << "Error opening file: " << filename << endl;
        exit(1);
    }
    Image_init(&image, fin);
    Matrix energy, cost;
    Matrix_init(&energy, 5, 5);
    compute_energy_matrix(&image, &energy);
    compute_vertical_cost_matrix(&energy, &cost);
    int seam[Matrix_height(&cost)];
    find_minimal_vertical_seam(&cost, seam);
    remove_vertical_seam(&image, seam);
    stringstream ss;
    Image_print(&image, ss);
    string output;
    string expected[] = {"P3", "4", "5", "255",
                         "0", "0", "0", "255", "255", "250", "0", "0", "0", "0", "0", "0",
                         "255", "255", "250", "126", "66", "0", "126", "66", "0", "255", "255", "250",
                         "126", "66", "0", "0", "0", "0", "0", "0", "0", "126", "66", "0",
                         "255", "219", "183", "255", "219", "183", "255", "219", "183", "255", "219", "183",
                         "255", "219", "183","134", "0", "0", "0", "0", "0", "255", "219", "183"};
    int count = 0;
    while(ss >> output) {
        ASSERT_EQUAL(output, expected[count++]);
    }
    fin.close();
}

TEST(seam_carve_width) {
    Image image;
    string filename = "dog.ppm";
    ifstream fin;
    fin.open(filename);
    if(!fin.is_open()) {
        cout << "Error opening file: " << filename << endl;
        exit(1);
    }
    Image_init(&image, fin);
    seam_carve_width(&image, 3);
    stringstream ss;
    Image_print(&image, ss);
    string output;
    string expected[] = {"P3", "3", "5", "255",
                         "0", "0", "0", "0", "0", "0", "0", "0", "0",
                         "255", "255", "250", "126", "66", "0", "255", "255", "250",
                         "126", "66", "0", "0", "0", "0", "126", "66", "0",
                         "255", "219", "183",  "255", "219", "183", "255", "219", "183",
                         "255", "219", "183", "0", "0", "0", "255", "219", "183"};
    int count = 0;
    while(ss >> output) {
        ASSERT_EQUAL(output, expected[count++]);
    }
    fin.close();
}

TEST(seam_carve_height) {
    Image image;
    string filename = "dog.ppm";
    ifstream fin;
    fin.open(filename);
    if(!fin.is_open()) {
        cout << "Error opening file: " << filename << endl;
        exit(1);
    }
    Image_init(&image, fin);
    seam_carve_height(&image, 4);
    stringstream ss;
    Image_print(&image, ss);
    string output;
    string expected[] = {"P3", "5", "4", "255",
                         "255", "255", "250", "0", "0", "0", "255", "255", "250", "0", "0", "0", "255", "255", "250",
                         "126", "66", "0", "0", "0", "0", "255", "219", "183", "0", "0", "0", "126", "66", "0",
                         "255", "219", "183", "255", "219", "183", "0", "0", "0", "255", "219", "183", "255", "219", "183",
                         "255", "219", "183", "0", "0", "0", "134", "0", "0", "0", "0", "0", "255", "219", "183"};
    int count = 0;
    while(ss >> output) {
        ASSERT_EQUAL(output, expected[count++]);
    }
    fin.close();
}

/*TEST(seam_carve) {
    Image image;
    string filename = "horses.ppm", ofilename = "output.ppm";
    ifstream fin;
    fin.open(filename);
    if(!fin.is_open()) {
        cout << "Error opening file: " << filename << endl;
        exit(1);
    }
    Image_init(&image, fin);
    seam_carve(&image, 20, 300);
    //stringstream ss;
    ofstream fout;
    fout.open(ofilename);
    if(!fout.is_open()) {
        cout << "Error opening file: " << ofilename << endl;
        exit(1);
    }
    Image_print(&image, fout);
    string output;
    string expected[] = {"P3", "5", "4", "255",
                         "255", "255", "250", "0", "0", "0", "255", "255", "250", "0", "0", "0", "255", "255", "250",
                         "126", "66", "0", "0", "0", "0", "255", "219", "183", "0", "0", "0", "126", "66", "0",
                         "255", "219", "183", "255", "219", "183", "0", "0", "0", "255", "219", "183", "255", "219", "183",
                         "255", "219", "183", "0", "0", "0", "134", "0", "0", "0", "0", "0", "255", "219", "183"};
    int count = 0;
    fin.close();
    fout.close();
}*/

TEST_MAIN();
