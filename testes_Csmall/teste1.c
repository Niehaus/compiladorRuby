int main() {

  int a = 10, b = 5;
  int i;

  for (i = 0; i < 10; i = i + 1)  {
    if (a < 10)     {
      a = (b + 1) * 3;
    } else {
      a = 30;
    }
    b = 60;
  }
}