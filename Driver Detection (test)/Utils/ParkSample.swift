import Foundation
import CoreMotion

struct Sample
{
  var heading: Double
  var acceleration: CMAcceleration
  func json() -> String
  {
    return "[\(heading),\(acceleration.x),\(acceleration.y),\(acceleration.z)]"
  }
}


class ParkSample
{
  var parkSamples = [Sample]()
  let parkSampleSize = 2048
  let parkSampleFreq = 0.1
  var curr = 0
    
  func add(_ sample:Sample)
  {
    if curr >= parkSampleSize
    {
      curr = 0
    }
    if parkSamples.count < parkSampleSize
    {
        parkSamples.append(sample)
    }
    else
    {
        parkSamples[curr] = sample
    }
    curr += 1
  }
  
  func json() -> String
  {
    var s = "{\n"
    var numEntries = 0
    for j in curr ..< parkSamples.count
    {
      s += "\"\(Double(j-curr)*parkSampleFreq)\":\(parkSamples[j].json())"
      numEntries += 1
        if numEntries < parkSamples.count {
            s += ","
        }
      s += "\n"
    }
    for j in 0 ..< curr
    {
        s += "\"\(Double(parkSamples.count-curr+j)*parkSampleFreq)\":\(parkSamples[j].json())"
        numEntries += 1
        if numEntries < parkSamples.count {
              s += ","
          }
        s += "\n"
    }
    s += "}"
    return s
  }
}
