import Tesseract from 'tesseract.js'

export interface OCRResult {
  text: string
  amount: number | null
  date: string | null
  confidence: number
}

/**
 * 画像の前処理: キャンバスを使ってグレースケール化とコントラスト調整
 */
export function preprocessImage(imageFile: File): Promise<string> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()

    reader.onload = (e) => {
      const img = new Image()
      img.onload = () => {
        const canvas = document.createElement('canvas')
        const ctx = canvas.getContext('2d')

        if (!ctx) {
          reject(new Error('Canvas context not available'))
          return
        }

        canvas.width = img.width
        canvas.height = img.height

        // 画像を描画
        ctx.drawImage(img, 0, 0)

        // グレースケール化とコントラスト調整
        const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height)
        const data = imageData.data

        for (let i = 0; i < data.length; i += 4) {
          // グレースケール化
          const avg = (data[i] + data[i + 1] + data[i + 2]) / 3

          // コントラスト調整 (簡易版)
          const contrast = 1.5
          const adjusted = ((avg - 128) * contrast) + 128
          const clamped = Math.max(0, Math.min(255, adjusted))

          data[i] = clamped     // R
          data[i + 1] = clamped // G
          data[i + 2] = clamped // B
        }

        ctx.putImageData(imageData, 0, 0)
        resolve(canvas.toDataURL('image/png'))
      }

      img.onerror = () => reject(new Error('Failed to load image'))
      img.src = e.target?.result as string
    }

    reader.onerror = () => reject(new Error('Failed to read file'))
    reader.readAsDataURL(imageFile)
  })
}

/**
 * テキストから金額を抽出
 */
export function extractAmount(text: string): number | null {
  // 日本円、ドル、ユーロなどの通貨記号と数字のパターン
  const patterns = [
    /[¥$€£]\s*(\d{1,3}(?:,\d{3})*(?:\.\d{2})?)/g,  // 通貨記号付き
    /(\d{1,3}(?:,\d{3})*(?:\.\d{2})?)\s*[¥$€£円元ドル]/g,  // 数字 + 通貨単位
    /合計[:：\s]*(\d{1,3}(?:,\d{3})*(?:\.\d{2})?)/gi,  // 「合計」キーワード
    /total[:：\s]*(\d{1,3}(?:,\d{3})*(?:\.\d{2})?)/gi,  // "Total"キーワード
    /(\d{1,3}(?:,\d{3})+)/g  // カンマ区切りの数字（大きい金額）
  ]

  const amounts: number[] = []

  for (const pattern of patterns) {
    let match
    while ((match = pattern.exec(text)) !== null) {
      const amountStr = match[1].replace(/,/g, '')
      const amount = parseFloat(amountStr)
      if (!isNaN(amount) && amount > 0) {
        amounts.push(amount)
      }
    }
  }

  // 最大の金額を返す（通常、合計金額が最大）
  return amounts.length > 0 ? Math.max(...amounts) : null
}

/**
 * テキストから日付を抽出
 */
export function extractDate(text: string): string | null {
  const today = new Date()

  // 日付パターン
  const patterns = [
    /(\d{4})[-/年](\d{1,2})[-/月](\d{1,2})/,  // YYYY-MM-DD, YYYY/MM/DD, YYYY年MM月DD日
    /(\d{1,2})[-/](\d{1,2})[-/](\d{4})/,      // MM-DD-YYYY, DD/MM/YYYY
    /(\d{4})(\d{2})(\d{2})/                    // YYYYMMDD
  ]

  for (const pattern of patterns) {
    const match = text.match(pattern)
    if (match) {
      let year, month, day

      if (pattern.source.includes('\\d{4}[-/年]')) {
        // YYYY-MM-DD形式
        year = parseInt(match[1])
        month = parseInt(match[2])
        day = parseInt(match[3])
      } else if (pattern.source.includes('\\d{1,2}[-/]\\d{1,2}[-/]\\d{4}')) {
        // DD-MM-YYYY形式（または MM-DD-YYYY）
        // 日本では DD-MM-YYYY が一般的なので、そちらを優先
        day = parseInt(match[1])
        month = parseInt(match[2])
        year = parseInt(match[3])
      } else {
        // YYYYMMDD形式
        year = parseInt(match[1])
        month = parseInt(match[2])
        day = parseInt(match[3])
      }

      // 妥当性チェック
      if (month >= 1 && month <= 12 && day >= 1 && day <= 31) {
        const date = new Date(year, month - 1, day)

        // 未来の日付は今日の日付として扱う
        if (date > today) {
          return today.toISOString().split('T')[0]
        }

        return date.toISOString().split('T')[0]
      }
    }
  }

  // 日付が見つからない場合は今日の日付
  return today.toISOString().split('T')[0]
}

/**
 * レシート画像からOCRでテキストを抽出し、金額と日付を解析
 */
export async function performOCR(imageFile: File): Promise<OCRResult> {
  try {
    // 画像の前処理
    const preprocessedImage = await preprocessImage(imageFile)

    // Tesseract.jsでOCR実行
    const result = await Tesseract.recognize(
      preprocessedImage,
      'jpn+eng',  // 日本語と英語
      {
        logger: (m) => {
          // 進捗ログ（オプション）
          if (m.status === 'recognizing text') {
            console.log(`OCR進捗: ${Math.round(m.progress * 100)}%`)
          }
        }
      }
    )

    const text = result.data.text
    const confidence = result.data.confidence

    // 金額と日付を抽出
    const amount = extractAmount(text)
    const date = extractDate(text)

    return {
      text,
      amount,
      date,
      confidence
    }
  } catch (error) {
    console.error('OCR処理エラー:', error)
    throw new Error('レシートの読み取りに失敗しました')
  }
}
