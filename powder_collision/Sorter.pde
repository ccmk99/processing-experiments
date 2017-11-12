
abstract class Sorter<T>
{
  int[] count;
  ArrayList<T> list;
  ArrayList<T> copy;
  
  Sorter(ArrayList<T> list, int max)
  {
    this.list = list;
    copy = new ArrayList<T>();
    count = new int[max];
  }
  
  void sort()
  {
    copy.clear();
    copy.addAll(list);
    for(int i=0;i<count.length;i++) {
      count[i] = 0;
    }
    for(T object : copy) {
      count[getValue(object)]++;
    }
    for(int i=1;i<count.length;i++) {
      count[i] += count[i-1];
    }
    for(int i=0;i<list.size();i++) {
      T target = copy.get(i);
      int value = getValue(target);
      list.set(count[value]-1,target);
      count[value]--;
    }
  }
  
  abstract int getValue(T data);
  
}