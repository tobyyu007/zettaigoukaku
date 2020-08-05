//
//  quizSearch.swift
//  zettaigoukaku
//
//  Created by Toby on 2020/8/1.
//  Copyright © 2020 Toby. All rights reserved.
//

import Foundation

extension quizViewController
{
    func search()
    {
        for index in 0...searchSelected.count-1
        {
            // MARK: 頁數
            if index == 0 && searchSelected[index] // 頁數
            {
                for word in FunctionsViewController.VocabulariesInstance
                {
                    if word.page >= pageRange[0] && word.page <= pageRange[1]
                    {
                        searchResults.append(contentsOf: [searchResult(star: word.star,
                                                                        page: word.page,
                                                                        volcabulary: word.volcabulary,
                                                                        kana: word.kana,
                                                                        japaneseDefinition: word.japaneseDefinition,
                                                                        chineseDefinition: word.chineseDefinition,
                                                                        type: word.type,
                                                                        sentence: word.sentence,
                                                                        sentence_chinese: word.sentence_chinese,
                                                                        level: word.level)] as [searchResult])
                    }
                }
            }
            // MARK: 日文
            else if index == 1 && searchSelected[index] // 日文
            {
                if !searchMethod[index] // 包含
                {
                    if !searchResults.isEmpty // 已經有在其他類型搜尋過
                    {
                        var removeIndex = [Int]()
                        for i in 0...searchResults.count-1 // 找出不符合的項目
                        {
                            if !searchResults[i].volcabulary.contains(japanese)
                            {
                                removeIndex.append(i)
                            }
                        }
                        if removeIndex.count != 0
                        {
                            for i in (0...removeIndex.count-1).reversed() // 移除不符合的結果
                            {
                                searchResults.remove(at: removeIndex[i])
                            }
                        }
                    }
                    else // 還沒搜尋過
                    {
                        for word in FunctionsViewController.VocabulariesInstance
                        {
                            if word.volcabulary.contains(japanese)
                            {
                                searchResults.append(contentsOf: [searchResult(star: word.star,
                                                                                page: word.page,
                                                                                volcabulary: word.volcabulary,
                                                                                kana: word.kana,
                                                                                japaneseDefinition: word.japaneseDefinition,
                                                                                chineseDefinition: word.chineseDefinition,
                                                                                type: word.type,
                                                                                sentence: word.sentence,
                                                                                sentence_chinese: word.sentence_chinese,
                                                                                level: word.level)] as [searchResult])
                            }
                        }
                    }
                }
                else // 完全相同
                {
                    if !searchResults.isEmpty // 已經有在其他類型搜尋過
                    {
                        var removeIndex = [Int]()
                        for i in 0...searchResults.count-1 // 找出不符合的項目
                        {
                            if searchResults[i].volcabulary != japanese
                            {
                                removeIndex.append(i)
                            }
                        }
                        if removeIndex.count != 0
                        {
                            for i in (0...removeIndex.count-1).reversed() // 移除不符合的結果
                            {
                                searchResults.remove(at: removeIndex[i])
                            }
                        }
                    }
                    else // 還沒搜尋過
                    {
                        for word in FunctionsViewController.VocabulariesInstance
                        {
                            if word.volcabulary == japanese
                            {
                                searchResults.append(contentsOf: [searchResult(star: word.star,
                                                                                page: word.page,
                                                                                volcabulary: word.volcabulary,
                                                                                kana: word.kana,
                                                                                japaneseDefinition: word.japaneseDefinition,
                                                                                chineseDefinition: word.chineseDefinition,
                                                                                type: word.type,
                                                                                sentence: word.sentence,
                                                                                sentence_chinese: word.sentence_chinese,
                                                                                level: word.level)] as [searchResult])
                            }
                        }
                    }
                }
            }
            // MARK: 假名
            else if index == 2 && searchSelected[index] // 假名
            {
                if !searchMethod[index] // 包含
                {
                    if !searchResults.isEmpty // 已經有在其他類型搜尋過
                    {
                        var removeIndex = [Int]()
                        for i in 0...searchResults.count-1 // 找出不符合的項目
                        {
                            if !searchResults[i].kana.contains(kana)
                            {
                                removeIndex.append(i)
                            }
                        }
                        if removeIndex.count != 0
                        {
                            for i in (0...removeIndex.count-1).reversed() // 移除不符合的結果
                            {
                                searchResults.remove(at: removeIndex[i])
                            }
                        }
                    }
                    else // 還沒搜尋過
                    {
                        for word in FunctionsViewController.VocabulariesInstance
                        {
                            if word.kana.contains(kana)
                            {
                                searchResults.append(contentsOf: [searchResult(star: word.star,
                                                                                page: word.page,
                                                                                volcabulary: word.volcabulary,
                                                                                kana: word.kana,
                                                                                japaneseDefinition: word.japaneseDefinition,
                                                                                chineseDefinition: word.chineseDefinition,
                                                                                type: word.type,
                                                                                sentence: word.sentence,
                                                                                sentence_chinese: word.sentence_chinese,
                                                                                level: word.level)] as [searchResult])
                            }
                        }
                    }
                }
                else // 完全相同
                {
                    if !searchResults.isEmpty // 已經有在其他類型搜尋過
                    {
                        var removeIndex = [Int]()
                        for i in 0...searchResults.count-1 // 找出不符合的項目
                        {
                            if searchResults[i].kana != kana
                            {
                                removeIndex.append(i)
                            }
                        }
                        if removeIndex.count != 0
                        {
                            for i in (0...removeIndex.count-1).reversed() // 移除不符合的結果
                            {
                                searchResults.remove(at: removeIndex[i])
                            }
                        }
                    }
                    else // 還沒搜尋過
                    {
                        for word in FunctionsViewController.VocabulariesInstance
                        {
                            if word.kana == kana
                            {
                                searchResults.append(contentsOf: [searchResult(star: word.star,
                                                                                page: word.page,
                                                                                volcabulary: word.volcabulary,
                                                                                kana: word.kana,
                                                                                japaneseDefinition: word.japaneseDefinition,
                                                                                chineseDefinition: word.chineseDefinition,
                                                                                type: word.type,
                                                                                sentence: word.sentence,
                                                                                sentence_chinese: word.sentence_chinese,
                                                                                level: word.level)] as [searchResult])
                            }
                        }
                    }
                }
            }
            // MARK: 日文解釋
            else if index == 3 && searchSelected[index] // 日文解釋
            {
                if !searchMethod[index] // 包含
                {
                    if !searchResults.isEmpty // 已經有在其他類型搜尋過
                    {
                        var removeIndex = [Int]()
                        for i in 0...searchResults.count-1 // 找出不符合的項目
                        {
                            if !searchResults[i].japaneseDefinition.contains(japaneseDescription)
                            {
                                removeIndex.append(i)
                            }
                        }
                        if removeIndex.count != 0
                        {
                            for i in (0...removeIndex.count-1).reversed() // 移除不符合的結果
                            {
                                searchResults.remove(at: removeIndex[i])
                            }
                        }
                    }
                    else // 還沒搜尋過
                    {
                        for word in FunctionsViewController.VocabulariesInstance
                        {
                            if word.japaneseDefinition.contains(japaneseDescription)
                            {
                                searchResults.append(contentsOf: [searchResult(star: word.star,
                                                                                page: word.page,
                                                                                volcabulary: word.volcabulary,
                                                                                kana: word.kana,
                                                                                japaneseDefinition: word.japaneseDefinition,
                                                                                chineseDefinition: word.chineseDefinition,
                                                                                type: word.type,
                                                                                sentence: word.sentence,
                                                                                sentence_chinese: word.sentence_chinese,
                                                                                level: word.level)] as [searchResult])
                            }
                        }
                    }
                }
                else // 完全相同
                {
                    if !searchResults.isEmpty // 已經有在其他類型搜尋過
                    {
                        var removeIndex = [Int]()
                        for i in 0...searchResults.count-1 // 找出不符合的項目
                        {
                            if searchResults[i].japaneseDefinition != japaneseDescription
                            {
                                removeIndex.append(i)
                            }
                        }
                        if removeIndex.count != 0
                        {
                            for i in (0...removeIndex.count-1).reversed() // 移除不符合的結果
                            {
                                searchResults.remove(at: removeIndex[i])
                            }
                        }
                    }
                    else // 還沒搜尋過
                    {
                        for word in FunctionsViewController.VocabulariesInstance
                        {
                            if word.japaneseDefinition == japaneseDescription
                            {
                                searchResults.append(contentsOf: [searchResult(star: word.star,
                                                                                page: word.page,
                                                                                volcabulary: word.volcabulary,
                                                                                kana: word.kana,
                                                                                japaneseDefinition: word.japaneseDefinition,
                                                                                chineseDefinition: word.chineseDefinition,
                                                                                type: word.type,
                                                                                sentence: word.sentence,
                                                                                sentence_chinese: word.sentence_chinese,
                                                                                level: word.level)] as [searchResult])
                            }
                        }
                    }
                }
            }
            // MARK: 中文解釋
            else if index == 4 && searchSelected[index] // 中文解釋
            {
                if !searchMethod[index] // 包含
                {
                    if !searchResults.isEmpty // 已經有在其他類型搜尋過
                    {
                        var removeIndex = [Int]()
                        for i in 0...searchResults.count-1 // 找出不符合的項目
                        {
                            if !searchResults[i].chineseDefinition.contains(chineseDescription)
                            {
                                removeIndex.append(i)
                            }
                        }
                        if removeIndex.count != 0
                        {
                            for i in (0...removeIndex.count-1).reversed() // 移除不符合的結果
                            {
                                searchResults.remove(at: removeIndex[i])
                            }
                        }
                    }
                    else // 還沒搜尋過
                    {
                        for word in FunctionsViewController.VocabulariesInstance
                        {
                            if word.chineseDefinition.contains(chineseDescription)
                            {
                                searchResults.append(contentsOf: [searchResult(star: word.star,
                                                                                page: word.page,
                                                                                volcabulary: word.volcabulary,
                                                                                kana: word.kana,
                                                                                japaneseDefinition: word.japaneseDefinition,
                                                                                chineseDefinition: word.chineseDefinition,
                                                                                type: word.type,
                                                                                sentence: word.sentence,
                                                                                sentence_chinese: word.sentence_chinese,
                                                                                level: word.level)] as [searchResult])
                            }
                        }
                    }
                }
                else // 完全相同
                {
                    if !searchResults.isEmpty // 已經有在其他類型搜尋過
                    {
                        var removeIndex = [Int]()
                        for i in 0...searchResults.count-1 // 找出不符合的項目
                        {
                            if searchResults[i].chineseDefinition != chineseDescription
                            {
                                removeIndex.append(i)
                            }
                        }
                        if removeIndex.count != 0
                        {
                            for i in (0...removeIndex.count-1).reversed() // 移除不符合的結果
                            {
                                searchResults.remove(at: removeIndex[i])
                            }
                        }
                    }
                    else // 還沒搜尋過
                    {
                        for word in FunctionsViewController.VocabulariesInstance
                        {
                            if word.chineseDefinition == chineseDescription
                            {
                                searchResults.append(contentsOf: [searchResult(star: word.star,
                                                                                page: word.page,
                                                                                volcabulary: word.volcabulary,
                                                                                kana: word.kana,
                                                                                japaneseDefinition: word.japaneseDefinition,
                                                                                chineseDefinition: word.chineseDefinition,
                                                                                type: word.type,
                                                                                sentence: word.sentence,
                                                                                sentence_chinese: word.sentence_chinese,
                                                                                level: word.level)] as [searchResult])
                            }
                        }
                    }
                }
            }
            // MARK: 類型
            else if index == 5 && searchSelected[index] // 類型
            {
                if !searchMethod[index] // 包含
                {
                    if !searchResults.isEmpty // 已經有在其他類型搜尋過
                    {
                        var removeIndex = [Int]()
                        for i in 0...searchResults.count-1 // 找出不符合的項目
                        {
                            if !searchResults[i].type.contains(type)
                            {
                                removeIndex.append(i)
                            }
                        }
                        if removeIndex.count != 0
                        {
                            for i in (0...removeIndex.count-1).reversed() // 移除不符合的結果
                            {
                                searchResults.remove(at: removeIndex[i])
                            }
                        }
                    }
                    else // 還沒搜尋過
                    {
                        for word in FunctionsViewController.VocabulariesInstance
                        {
                            if word.type.contains(type)
                            {
                                searchResults.append(contentsOf: [searchResult(star: word.star,
                                                                                page: word.page,
                                                                                volcabulary: word.volcabulary,
                                                                                kana: word.kana,
                                                                                japaneseDefinition: word.japaneseDefinition,
                                                                                chineseDefinition: word.chineseDefinition,
                                                                                type: word.type,
                                                                                sentence: word.sentence,
                                                                                sentence_chinese: word.sentence_chinese,
                                                                                level: word.level)] as [searchResult])
                            }
                        }
                    }
                }
                else // 完全相同
                {
                    if !searchResults.isEmpty // 已經有在其他類型搜尋過
                    {
                        var removeIndex = [Int]()
                        for i in 0...searchResults.count-1 // 找出不符合的項目
                        {
                            if searchResults[i].type != type
                            {
                                removeIndex.append(i)
                            }
                        }
                        if removeIndex.count != 0
                        {
                            for i in (0...removeIndex.count-1).reversed() // 移除不符合的結果
                            {
                                searchResults.remove(at: removeIndex[i])
                            }
                        }
                    }
                    else // 還沒搜尋過
                    {
                        for word in FunctionsViewController.VocabulariesInstance
                        {
                            if word.type == type
                            {
                                searchResults.append(contentsOf: [searchResult(star: word.star,
                                                                                page: word.page,
                                                                                volcabulary: word.volcabulary,
                                                                                kana: word.kana,
                                                                                japaneseDefinition: word.japaneseDefinition,
                                                                                chineseDefinition: word.chineseDefinition,
                                                                                type: word.type,
                                                                                sentence: word.sentence,
                                                                                sentence_chinese: word.sentence_chinese,
                                                                                level: word.level)] as [searchResult])
                            }
                        }
                    }
                }
            }
            // MARK: 日文例句
            else if index == 6 && searchSelected[index] // 日文例句
            {
                if !searchMethod[index] // 包含
                {
                    if !searchResults.isEmpty // 已經有在其他類型搜尋過
                    {
                        var removeIndex = [Int]()
                        for i in 0...searchResults.count-1 // 找出不符合的項目
                        {
                            if !searchResults[i].sentence.contains(example)
                            {
                                removeIndex.append(i)
                            }
                        }
                        if removeIndex.count != 0
                        {
                            for i in (0...removeIndex.count-1).reversed() // 移除不符合的結果
                            {
                                searchResults.remove(at: removeIndex[i])
                            }
                        }
                    }
                    else // 還沒搜尋過
                    {
                        for word in FunctionsViewController.VocabulariesInstance
                        {
                            if word.sentence.contains(example)
                            {
                                searchResults.append(contentsOf: [searchResult(star: word.star,
                                                                                page: word.page,
                                                                                volcabulary: word.volcabulary,
                                                                                kana: word.kana,
                                                                                japaneseDefinition: word.japaneseDefinition,
                                                                                chineseDefinition: word.chineseDefinition,
                                                                                type: word.type,
                                                                                sentence: word.sentence,
                                                                                sentence_chinese: word.sentence_chinese,
                                                                                level: word.level)] as [searchResult])
                            }
                        }
                    }
                }
                else // 完全相同
                {
                    if !searchResults.isEmpty // 已經有在其他類型搜尋過
                    {
                        var removeIndex = [Int]()
                        for i in 0...searchResults.count-1 // 找出不符合的項目
                        {
                            if searchResults[i].sentence != example
                            {
                                removeIndex.append(i)
                            }
                        }
                        if removeIndex.count != 0
                        {
                            for i in (0...removeIndex.count-1).reversed() // 移除不符合的結果
                            {
                                searchResults.remove(at: removeIndex[i])
                            }
                        }
                    }
                    else // 還沒搜尋過
                    {
                        for word in FunctionsViewController.VocabulariesInstance
                        {
                            if word.sentence == example
                            {
                                searchResults.append(contentsOf: [searchResult(star: word.star,
                                                                                page: word.page,
                                                                                volcabulary: word.volcabulary,
                                                                                kana: word.kana,
                                                                                japaneseDefinition: word.japaneseDefinition,
                                                                                chineseDefinition: word.chineseDefinition,
                                                                                type: word.type,
                                                                                sentence: word.sentence,
                                                                                sentence_chinese: word.sentence_chinese,
                                                                                level: word.level)] as [searchResult])
                            }
                        }
                    }
                }
            }
            // MARK: 中文例句
            else if index == 7 && searchSelected[index] // 中文例句
            {
                if !searchMethod[index] // 包含
                {
                    if !searchResults.isEmpty // 已經有在其他類型搜尋過
                    {
                        var removeIndex = [Int]()
                        for i in 0...searchResults.count-1 // 找出不符合的項目
                        {
                            if !searchResults[i].sentence_chinese.contains(exampleChinese)
                            {
                                removeIndex.append(i)
                            }
                        }
                        if removeIndex.count != 0
                        {
                            for i in (0...removeIndex.count-1).reversed() // 移除不符合的結果
                            {
                                searchResults.remove(at: removeIndex[i])
                            }
                        }
                    }
                    else // 還沒搜尋過
                    {
                        for word in FunctionsViewController.VocabulariesInstance
                        {
                            if word.sentence_chinese.contains(exampleChinese)
                            {
                                searchResults.append(contentsOf: [searchResult(star: word.star,
                                                                                page: word.page,
                                                                                volcabulary: word.volcabulary,
                                                                                kana: word.kana,
                                                                                japaneseDefinition: word.japaneseDefinition,
                                                                                chineseDefinition: word.chineseDefinition,
                                                                                type: word.type,
                                                                                sentence: word.sentence,
                                                                                sentence_chinese: word.sentence_chinese,
                                                                                level: word.level)] as [searchResult])
                            }
                        }
                    }
                }
                else // 完全相同
                {
                    if !searchResults.isEmpty // 已經有在其他類型搜尋過
                    {
                        var removeIndex = [Int]()
                        for i in 0...searchResults.count-1 // 找出不符合的項目
                        {
                            if searchResults[i].sentence_chinese != exampleChinese
                            {
                                removeIndex.append(i)
                            }
                        }
                        if removeIndex.count != 0
                        {
                            for i in (0...removeIndex.count-1).reversed() // 移除不符合的結果
                            {
                                searchResults.remove(at: removeIndex[i])
                            }
                        }
                    }
                    else // 還沒搜尋過
                    {
                        for word in FunctionsViewController.VocabulariesInstance
                        {
                            if word.sentence_chinese == exampleChinese
                            {
                                searchResults.append(contentsOf: [searchResult(star: word.star,
                                                                                page: word.page,
                                                                                volcabulary: word.volcabulary,
                                                                                kana: word.kana,
                                                                                japaneseDefinition: word.japaneseDefinition,
                                                                                chineseDefinition: word.chineseDefinition,
                                                                                type: word.type,
                                                                                sentence: word.sentence,
                                                                                sentence_chinese: word.sentence_chinese,
                                                                                level: word.level)] as [searchResult])
                            }
                        }
                    }
                }
            }
            // MARK: 級別
            else if index == 8 && searchSelected[index] // 級別
            {
                if !searchResults.isEmpty // 已經有在其他類型搜尋過
                {
                    var removeIndex = [Int]()
                    for i in 0...searchResults.count-1 // 找出不符合的項目
                    {
                        var levelInt: Int
                        switch searchResults[i].level{
                        case "N5":
                            levelInt = 5
                        case "N4":
                            levelInt = 4
                        case "N3":
                            levelInt = 3
                        case "N2":
                            levelInt = 2
                        case "N1":
                            levelInt = 1
                        default:
                            levelInt = 0
                        }
                        
                        if levelInt > level[0] || levelInt < level[1]
                        {
                            removeIndex.append(i)
                        }
                    }
                    if removeIndex.count != 0
                    {
                        for i in (0...removeIndex.count-1).reversed() // 移除不符合的結果
                        {
                            searchResults.remove(at: removeIndex[i])
                        }
                    }
                }
                else // 還沒搜尋過
                {
                    for word in FunctionsViewController.VocabulariesInstance
                    {
                        var levelInt: Int
                        switch word.level{
                        case "N5":
                            levelInt = 5
                        case "N4":
                            levelInt = 4
                        case "N3":
                            levelInt = 3
                        case "N2":
                            levelInt = 2
                        case "N1":
                            levelInt = 1
                        default:
                            levelInt = 0
                        }
                        if levelInt <= level[0] && levelInt >= level[1]
                        {
                            searchResults.append(contentsOf: [searchResult(star: word.star,
                                                                            page: word.page,
                                                                            volcabulary: word.volcabulary,
                                                                            kana: word.kana,
                                                                            japaneseDefinition: word.japaneseDefinition,
                                                                            chineseDefinition: word.chineseDefinition,
                                                                            type: word.type,
                                                                            sentence: word.sentence,
                                                                            sentence_chinese: word.sentence_chinese,
                                                                            level: word.level)] as [searchResult])
                        }
                    }
                }
            }
            // MARK: 標記
            else if index == 9 && searchSelected[index] // 標記
            {
                if !searchResults.isEmpty // 已經有在其他類型搜尋過
                {
                    var removeIndex = [Int]()
                    for i in 0...searchResults.count-1 // 找出不符合的項目
                    {
                        if searchResults[i].star != star
                        {
                            removeIndex.append(i)
                        }
                    }
                    if removeIndex.count != 0
                    {
                        for i in (0...removeIndex.count-1).reversed() // 移除不符合的結果
                        {
                            searchResults.remove(at: removeIndex[i])
                        }
                    }
                    
                }
                else // 還沒搜尋過
                {
                    for word in FunctionsViewController.VocabulariesInstance
                    {
                        if word.star == star
                        {
                            searchResults.append(contentsOf: [searchResult(star: word.star,
                                                                            page: word.page,
                                                                            volcabulary: word.volcabulary,
                                                                            kana: word.kana,
                                                                            japaneseDefinition: word.japaneseDefinition,
                                                                            chineseDefinition: word.chineseDefinition,
                                                                            type: word.type,
                                                                            sentence: word.sentence,
                                                                            sentence_chinese: word.sentence_chinese,
                                                                            level: word.level)] as [searchResult])
                        }
                    }
                }
            }
        }
    }
}
