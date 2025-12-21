export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      users: {
        Row: {
          id: string
          email: string
          display_name: string | null
          profile_image_url: string | null
          onboarding_completed: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id: string
          email: string
          display_name?: string | null
          profile_image_url?: string | null
          onboarding_completed?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          email?: string
          display_name?: string | null
          profile_image_url?: string | null
          onboarding_completed?: boolean
          created_at?: string
          updated_at?: string
        }
      }
      trips: {
        Row: {
          id: string
          user_id: string
          name: string
          destination: string | null
          start_date: string
          end_date: string | null
          budget: number | null
          currency: string
          description: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          user_id: string
          name: string
          destination?: string | null
          start_date: string
          end_date?: string | null
          budget?: number | null
          currency: string
          description?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          name?: string
          destination?: string | null
          start_date?: string
          end_date?: string | null
          budget?: number | null
          currency?: string
          description?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      expenses: {
        Row: {
          id: string
          trip_id: string
          user_id: string
          amount: number
          currency: string
          category_id: string | null
          payment_method: string | null
          description: string | null
          expense_date: string
          location: string | null
          notes: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          trip_id: string
          user_id: string
          amount: number
          currency: string
          category_id?: string | null
          payment_method?: string | null
          description?: string | null
          expense_date: string
          location?: string | null
          notes?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          trip_id?: string
          user_id?: string
          amount?: number
          currency?: string
          category_id?: string | null
          payment_method?: string | null
          description?: string | null
          expense_date?: string
          location?: string | null
          notes?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      categories: {
        Row: {
          id: string
          user_id: string | null
          name: string
          icon: string | null
          color: string | null
          is_default: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          user_id?: string | null
          name: string
          icon?: string | null
          color?: string | null
          is_default?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          user_id?: string | null
          name?: string
          icon?: string | null
          color?: string | null
          is_default?: boolean
          created_at?: string
          updated_at?: string
        }
      }
      tags: {
        Row: {
          id: string
          user_id: string
          name: string
          color: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          user_id: string
          name: string
          color?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          user_id?: string
          name?: string
          color?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      expense_tags: {
        Row: {
          expense_id: string
          tag_id: string
          created_at: string
        }
        Insert: {
          expense_id: string
          tag_id: string
          created_at?: string
        }
        Update: {
          expense_id?: string
          tag_id?: string
          created_at?: string
        }
      }
      expense_images: {
        Row: {
          id: string
          expense_id: string
          image_url: string
          thumbnail_url: string | null
          ocr_text: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          expense_id: string
          image_url: string
          thumbnail_url?: string | null
          ocr_text?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          expense_id?: string
          image_url?: string
          thumbnail_url?: string | null
          ocr_text?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      category_budgets: {
        Row: {
          id: string
          trip_id: string
          category_id: string
          budget_amount: number
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          trip_id: string
          category_id: string
          budget_amount: number
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          trip_id?: string
          category_id?: string
          budget_amount?: number
          created_at?: string
          updated_at?: string
        }
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      [_ in never]: never
    }
  }
}
