import { useState, useRef } from 'react'
import Webcam from 'react-webcam'
import { performOCR, type OCRResult } from '../lib/ocr'
import { Button } from './Button'
import toast from 'react-hot-toast'

interface ReceiptScannerProps {
  onScanComplete: (result: OCRResult) => void
  onClose: () => void
}

export function ReceiptScanner({ onScanComplete, onClose }: ReceiptScannerProps) {
  const [isScanning, setIsScanning] = useState(false)
  const [capturedImage, setCapturedImage] = useState<string | null>(null)
  const [useCamera, setUseCamera] = useState(false)
  const webcamRef = useRef<Webcam>(null)
  const fileInputRef = useRef<HTMLInputElement>(null)

  // カメラで撮影
  const capturePhoto = () => {
    if (webcamRef.current) {
      const imageSrc = webcamRef.current.getScreenshot()
      if (imageSrc) {
        setCapturedImage(imageSrc)
      }
    }
  }

  // ギャラリーから選択
  const handleFileSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (file) {
      const reader = new FileReader()
      reader.onload = (event) => {
        setCapturedImage(event.target?.result as string)
      }
      reader.readAsDataURL(file)
    }
  }

  // OCR処理を実行
  const processImage = async () => {
    if (!capturedImage) return

    setIsScanning(true)

    try {
      // Base64をFileオブジェクトに変換
      const response = await fetch(capturedImage)
      const blob = await response.blob()
      const file = new File([blob], 'receipt.jpg', { type: 'image/jpeg' })

      // OCR実行
      const result = await performOCR(file)

      if (result.confidence < 50) {
        toast.error('読み取り精度が低いです。別の画像を試してください。')
        return
      }

      // 成功時はコールバックを実行
      onScanComplete(result)
      toast.success('レシートを読み取りました！')
      onClose()
    } catch (error) {
      console.error('OCR処理エラー:', error)
      toast.error('レシートの読み取りに失敗しました')
    } finally {
      setIsScanning(false)
    }
  }

  // 再撮影
  const retake = () => {
    setCapturedImage(null)
  }

  return (
    <div className="fixed inset-0 bg-black/70 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-xl max-w-2xl w-full max-h-[90vh] overflow-auto">
        {/* Header */}
        <div className="flex items-center justify-between p-6 border-b">
          <h2 className="text-2xl font-bold text-neutral-dark">レシートをスキャン</h2>
          <button
            onClick={onClose}
            className="text-neutral hover:text-neutral-dark transition-colors"
          >
            <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        {/* Content */}
        <div className="p-6 space-y-6">
          {!useCamera && !capturedImage && (
            <div className="space-y-4">
              <p className="text-neutral text-center">レシート画像を選択してください</p>

              <div className="flex flex-col gap-4">
                {/* カメラで撮影 */}
                <Button
                  onClick={() => setUseCamera(true)}
                  className="flex items-center justify-center gap-2"
                >
                  <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
                  </svg>
                  カメラで撮影
                </Button>

                {/* ギャラリーから選択 */}
                <input
                  ref={fileInputRef}
                  type="file"
                  accept="image/*"
                  onChange={handleFileSelect}
                  className="hidden"
                />
                <Button
                  variant="outline"
                  onClick={() => fileInputRef.current?.click()}
                  className="flex items-center justify-center gap-2"
                >
                  <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                  </svg>
                  ギャラリーから選択
                </Button>
              </div>
            </div>
          )}

          {/* カメラビュー */}
          {useCamera && !capturedImage && (
            <div className="space-y-4">
              <div className="relative aspect-video bg-black rounded-lg overflow-hidden">
                <Webcam
                  ref={webcamRef}
                  audio={false}
                  screenshotFormat="image/jpeg"
                  className="w-full h-full object-cover"
                />
              </div>

              <div className="flex gap-4">
                <Button
                  variant="outline"
                  onClick={() => setUseCamera(false)}
                  className="flex-1"
                >
                  戻る
                </Button>
                <Button
                  onClick={capturePhoto}
                  className="flex-1 flex items-center justify-center gap-2"
                >
                  <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z" />
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 13a3 3 0 11-6 0 3 3 0 016 0z" />
                  </svg>
                  撮影
                </Button>
              </div>
            </div>
          )}

          {/* キャプチャ画像のプレビュー */}
          {capturedImage && (
            <div className="space-y-4">
              <div className="relative aspect-video bg-neutral-light rounded-lg overflow-hidden">
                <img
                  src={capturedImage}
                  alt="Captured receipt"
                  className="w-full h-full object-contain"
                />
              </div>

              <div className="flex gap-4">
                <Button
                  variant="outline"
                  onClick={retake}
                  disabled={isScanning}
                  className="flex-1"
                >
                  再撮影
                </Button>
                <Button
                  onClick={processImage}
                  isLoading={isScanning}
                  disabled={isScanning}
                  className="flex-1"
                >
                  {isScanning ? 'スキャン中...' : 'スキャン実行'}
                </Button>
              </div>

              {isScanning && (
                <div className="text-center text-sm text-neutral">
                  <p>レシートを読み取り中です...</p>
                  <p className="mt-1">これには数秒かかる場合があります</p>
                </div>
              )}
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
