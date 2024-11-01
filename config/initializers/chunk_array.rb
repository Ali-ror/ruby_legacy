def chunk_array(array, pieces=2)
  len = array.length;
  mid = (len/pieces)
  chunks = []
  start = 0
  1.upto(pieces) do |i|
    last = start+mid
    last = last-1 unless len%pieces >= i
    chunks << array[start..last] || []
    start = last+1
  end
  chunks
end