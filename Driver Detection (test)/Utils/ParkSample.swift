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
    parkSamples[curr] = sample
    curr += 1
  }
  
  func json() -> String
  {
    var s = ""
    for j in curr ..< parkSampleSize
    {
      s += "\"\(Double(j-curr)*parkSampleFreq)\":\(parkSamples[j].json())"
    }
    for j in 0 ..< curr
    {
      s += "\"\(Double(parkSampleSize-curr+j))\":\(parkSamples[j].json()))"
    }
    return s
  }
}
